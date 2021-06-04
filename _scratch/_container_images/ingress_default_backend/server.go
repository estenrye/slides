package main
import (
	"context"
	"flag"
	"fmt"
	"html/template"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"time"
	"github.com/gorilla/mux"
	log "github.com/sirupsen/logrus"
)
var dynamicReload bool
var title string
var byline string

var htmlTemplatePath string = "templates/index.tmpl.htm"
var htmlTemplate *template.Template
var jsonTemplatePath string = "templates/index.tmpl.json"
var jsonTemplate *template.Template
var defaultTemplateHtml string = `<html>
  <title>{{ .Title }}</title>
  <body>
    <h1>Default Backend</h1>
	<h2>{{ .StatusCode }}</h2>
	<p>{{ .ByLine }}</p>
  </body>
</html>"
`
var defaultTemplateJson string = `{
	"title": "{{ .Title }}",
	"statusCode": "{{ .StatusCode }}",
	"byLine": "{{ .ByLine }}"
}
`

// PageData represents the data to return to the client
type PageData struct {
	Title string
	ByLine string
	StatusCode  int
}

func templateHandler(w http.ResponseWriter, r *http.Request, statusCode int, templateType string) {
	data := PageData {
		Title: title,
		ByLine: byline,
		StatusCode: statusCode,
	}

	templatePath := htmlTemplatePath
	defaultTemplateString := defaultTemplateHtml
	preloadedTemplate := htmlTemplate

	if "json" == templateType {
		templatePath = jsonTemplatePath
		defaultTemplateString = defaultTemplateJson
		preloadedTemplate = jsonTemplate
	}

	w.WriteHeader(data.StatusCode)
	if dynamicReload {
		t, err := template.ParseFiles(templatePath)
		if err != nil {
			log.WithError(err).Warning("Unable to find template.  Using default.")
			t = template.Must(template.New("index").Parse(defaultTemplateString))
		}
		t.Execute(w, data)
	} else {
		preloadedTemplate.Execute(w, data)
	}
}

func htmlTemplateHandler(w http.ResponseWriter, r *http.Request, statusCode int) {
	templateHandler(w, r, statusCode, "html")
}

func jsonTemplateHandler(w http.ResponseWriter, r *http.Request, statusCode int) {
	templateHandler(w, r, statusCode, "json")
}

// IngressDefaultBackendHtmlHandler handles requests
func IngressDefaultBackendHtmlHandler(w http.ResponseWriter, r *http.Request) {
	htmlTemplateHandler(w, r, 404)
}

// IngressDefaultBackendJsonHandler handles requests
func IngressDefaultBackendJsonHandler(w http.ResponseWriter, r *http.Request) {
	jsonTemplateHandler(w, r, 404)
}

// CustomErrorPageBackendHtmlHandler handles requests
func CustomErrorPageBackendHtmlHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	statusCode, err := strconv.Atoi(vars["statusCode"])
	if err != nil {
		statusCode = 2500
		log.WithError(err).Warning("Invalid Route, status code could not be converted.")
	}
	htmlTemplateHandler(w, r, statusCode)
}

// CustomErrorPageBackendJsonHandler handles requests
func CustomErrorPageBackendJsonHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	statusCode, err := strconv.Atoi(vars["statusCode"])
	if err != nil {
		statusCode = 2500
		log.WithError(err).Warning("Invalid Route, status code could not be converted.")
	}
	jsonTemplateHandler(w, r, statusCode)
}

// HealthCheckHtmlHandler returns healthcheck
func HealthCheckHtmlHandler(w http.ResponseWriter, r *http.Request) {
	htmlTemplateHandler(w, r, 200)
}
// HealthCheckJsonHandler returns healthcheck
func HealthCheckJsonHandler(w http.ResponseWriter, r *http.Request) {
	jsonTemplateHandler(w, r, 200)
}

func main() {
	log.SetFormatter(&log.JSONFormatter{})
	var wait time.Duration
	flag.DurationVar(&wait, "graceful-timeout", time.Second*15, "the duration for which the server gracefully wait for existing connections to finish - e.g. 15s or 1m")
	var flagTitle = flag.String("title", "Default Ingress Backend", "Specifies the default backend .Title value.")
	var flagByLine = flag.String("byline", "Platform Team", "Specifies the default backend .ByLine value.")
	var flagPort = flag.Int("port", 8080, "Specifies the port to listen for requests.")
	var flagDynamicTemplateReload = flag.Bool("enable-dynamic-templates", false, "Enables Reload of templates on every request for testing.  (default false)")
	var flagLogLevel = flag.String("log-level", "info", "Sets the log verbosity.")
	flag.Parse()
	switch *flagLogLevel {
	case "info":
		log.SetLevel(log.InfoLevel)
	case "warn":
		log.SetLevel(log.WarnLevel)
	case "debug":
		log.SetLevel(log.DebugLevel)
	case "error":
		log.SetLevel(log.ErrorLevel)
	default:
		log.SetLevel(log.InfoLevel)
	}
	var addr = fmt.Sprintf("0.0.0.0:%d", *flagPort)
	title = *flagTitle
	byline = *flagByLine
	dynamicReload = *flagDynamicTemplateReload

	var err error
	htmlTemplate, err = template.ParseFiles(htmlTemplatePath)
	if err != nil {
		log.WithError(err).Warning("Unable to find html template.  Using default.")
		htmlTemplate = template.Must(template.New("index").Parse(defaultTemplateHtml))
	}

	jsonTemplate, err = template.ParseFiles(jsonTemplatePath)
	if err != nil {
		log.WithError(err).Warning("Unable to find json template.  Using default.")
		jsonTemplate = template.Must(template.New("index").Parse(defaultTemplateJson))
	}

	r := mux.NewRouter()
	r.HandleFunc("/{statusCode:[0-9]+}.html", CustomErrorPageBackendHtmlHandler)
	r.HandleFunc("/{statusCode:[0-9]+}.htm", CustomErrorPageBackendHtmlHandler)
	r.HandleFunc("/{statusCode:[0-9]+}.json", CustomErrorPageBackendJsonHandler)
	r.Headers("Content-Type", "application/json").Path("/healthz").HandlerFunc(HealthCheckJsonHandler)
	r.Headers("Content-Type", "application/json").Path("/readiness").HandlerFunc(HealthCheckJsonHandler)
	r.Headers("Content-Type", "application/json").Path("/liveness").HandlerFunc(HealthCheckJsonHandler)
	r.Headers("Content-Type", "application/json").PathPrefix("/").HandlerFunc(IngressDefaultBackendJsonHandler)
	r.Path("/healthz").HandlerFunc(HealthCheckHtmlHandler)
	r.Path("/readiness").HandlerFunc(HealthCheckHtmlHandler)
	r.Path("/liveness").HandlerFunc(HealthCheckHtmlHandler)
	r.PathPrefix("/").HandlerFunc(IngressDefaultBackendHtmlHandler)
	srv := &http.Server{
		Addr: addr,
		// Good practice to set timeouts to avoid Slowloris attacks.
		WriteTimeout: time.Second * 15,
		ReadTimeout:  time.Second * 15,
		IdleTimeout:  time.Second * 60,
		Handler:      r, // Pass our instance of gorilla/mux in.
	}
	go func() {
		log.
			WithField("addr", addr).
			Info("Starting server")
		if err := srv.ListenAndServe(); err != nil {
			log.Error(err)
		}
	}()
	c := make(chan os.Signal, 1)
	// We'll accept graceful shutdowns when quit via SIGINT (Ctrl+C)
	// SIGKILL, SIGQUIT or SIGTERM (Ctrl+/) will not be caught.
	signal.Notify(c, os.Interrupt)
	signal.Notify(c, os.Kill)
	// Block until we receive our signal.
	<-c
	log.Info("shutting down")
	// Create a deadline to wait for.
	ctx, cancel := context.WithTimeout(context.Background(), wait)
	defer cancel()
	// Doesn't block if no connections, but will otherwise wait
	// until the timeout deadline.
	srv.Shutdown(ctx)
	// Optionally, you could run srv.Shutdown in a goroutine and block on
	// <-ctx.Done() if your application should wait for other services
	// to finalize based on context cancellation.
	os.Exit(0)
}