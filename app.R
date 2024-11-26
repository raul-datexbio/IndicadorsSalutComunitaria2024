# Carregar llibreries
library(bslib)
library(DT)
library(GWalkR)
library(readr)
library(shiny)
library(shinyjs)
library(shinythemes)

################################################################################

# Carregar CSV
df <- read.csv('https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/Indicadors_ABS.csv',
               sep = ",", encoding = "latin1", check.names = FALSE)

################################################################################

# Interfície d'usuari
ui <- fluidPage(
  
  # Activar shinyjs
  useShinyjs(),  
  
  # Tema
  theme = shinytheme("paper"),
  
  # Adaptar la interfície a diferents dispositius
  responsive = TRUE,
  
  # Títol a la pestanya del navegador
  title = "Indicadors de Salut Comunitària (2024)",
  
  # Títol a la interfície
  titlePanel(
    div(
      style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 48px; color: #5EAEFF; 
      background-color: white; text-align: left; margin-top: 100px; padding: 20px;",
      "Indicadors de Salut Comunitària – Edició 2024")
  ),
  
  # Panell de capçalera
  headerPanel(
    div(
      style = "position: fixed; top: 0; left: 0; right: 0; display: flex; justify-content: space-between; padding: 10px; 
               background-color: #5EAEFF; z-index: 10;",
      
      # Contenidor lateral esquerra
      div(
        style = "margin-top: -10px;; margin-left: 20px;",
        tags$a(
          href = "https://salutweb.gencat.cat/ca/inici",
          target = "_blank",
          img(
            src = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/salut_logotip_negatiu.png", 
            alt = "salut_logotip", 
            height = "40px"
          ),
          title = "Pàgina web Salut"
        )
      ),
      
      # Contenidor lateral dret
      div(
        style = "display: flex; align-items: center; gap: 15px; margin-right: 20px;",
        actionLink(
          inputId = "anar_pestanya_inici", 
          label = icon("home"), 
          style = "font-size: 20px; color: white; text-decoration: none;",
          title = "Inici"
        ),
        tags$a(
          href = "https://ovt.gencat.cat/gsitfc/AppJava/generic/conqxsGeneric.do?webFormId=391&topicLevel1.id=1523&set-locale=ca_ES",
          icon("envelope"),
          style = "font-size: 20px; color: white; text-decoration: none;",
          title = "Bústia de contacte"
        )
      )
    )
  ),
  
  # Peu de pàgina
  tags$footer(
    style = "position: fixed; bottom: 0; left: 0; right: 0; padding: 5px; background-color: #f8f9fa; 
             border-top: 1px solid #5EAEFF; font-size: 16px; z-index: 10;", 
    
    # Contenidor principal
    div(
      style = "display: flex; justify-content: space-between; ",
      
      # Contenidor lateral esquerra
      div(
        style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; color: #5EAEFF; margin-left: 20px;", 
        HTML("© 2024, 
         <a href='https://web.gencat.cat/ca/inici' target='_blank' style='color: #5EAEFF;' title='Pàgina web Generalitat de Catalunya'>Generalitat Catalunya</a>,
         <a href='https://salutweb.gencat.cat/ca/inici' target='_blank' style='color: #5EAEFF;' title='Pàgina web Departament de Salut'>Departament de Salut</a>,
         <a href='https://creativecommons.org/licenses/by-nc-nd/4.0/deed.ca' target='_blank' style='color: #5EAEFF;' title='Pàgina web llicència CC BY-NC-ND 4.0'>CC BY-NC-ND 4.0</a>")
      ),
      
      # Contenidor lateral dret
      div(
        style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; color: #5EAEFF; margin-right: 20px; gap: 15px; display: flex;",
        span("Segueix les xarxes socials de Salut:"),
        tags$a(
          href = "https://x.com/salutcat",
          target = "_blank",
          icon("x-twitter"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "Twitter Salut"
        ),
        tags$a(
          href = "https://www.facebook.com/salutcat",
          target = "_blank",
          icon("facebook-f"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "Facebook Salut"
        ),
        tags$a(
          href = "https://www.instagram.com/salut_cat/",
          target = "_blank",
          icon("instagram"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "Instagram Salut"
        ),
        tags$a(
          href = "https://t.me/salutcat",
          target = "_blank",
          icon("telegram"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "Telegram Salut"
        ),
        tags$a(
          href = "https://www.linkedin.com/company/salutcat",
          target = "_blank",
          icon("linkedin"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "LinkedIn Salut"
        ),
        tags$a(
          href = "https://www.youtube.com/salutgeneralitat",
          target = "_blank",
          icon("youtube"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "YouTube Salut"
        ),
        tags$a(
          href = "https://canalsalut.gencat.cat/ca/actualitat/butlletins/",
          target = "_blank",
          icon("file-lines"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "Butlletins Salut"
        ),
        tags$a(
          href = "https://canalsalut.gencat.cat/ca/actualitat/xarxes-socials/",
          target = "_blank",
          icon("share-nodes"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "Xarxes socials Salut"
        )
      )
    )
  ),
  
  # Panell principal
  mainPanel(
    style = "margin-top: 10px; margin-bottom: 100px; margin-right: 0px; margin-left: 0px; width: 100%;",
    
    # Conjunt de pestanyes
    tabsetPanel(
      
      # ID per identificar les pestanyes
      id = "tabs",
      
      # Pestanya 'Inici'
      tabPanel(
        
        # Títol de la pestanya
        title = tagList(icon("home", style = "font-size: 18px;"), 
                        span("Inici", 
                             style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 18px; color: #5E5E5E;")), 
        
        # Valor per identificar la pestanya
        value = "tab_inici",
        
        # Contingut
        div(
          style = "padding: 20px;",
          
          # Presentació
          card(
            card_header(
              h1("Presentació", 
                 style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 36px; color: #5EAEFF; 
                 background-color: white; text-align: left; margin-top: 0px; padding: 0px;")
            ),
            card_body(
              p(
                style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 16px; color: #5E5E5E; text-align: justify; line-height: 1.5;",
                "Per desplegar l'orientació comunitària és fonamental disposar de dades fiables i robustes per àrees petites, 
                que permetin fer una primera aproximació al diagnòstic comunitari. Per tal de facilitar aquesta part metodològica 
                de l'acció comunitària, en el marc del Pla de Salut, s'han seleccionat i calculat un conjunt d'indicadors bàsics 
                a nivell d'àrees bàsiques de salut (ABS) seguint el marc conceptual dels determinats socials de la salut."
              )
            )
          ),
          
          br(),
          
          # Autoria
          card(
            card_header(
              h2("Autoria", 
                 style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 24px; color: #5EAEFF; background-color: white; 
                 text-align: left; margin-top: 0px; padding: 0px;")
            ),
            card_body(
              p(
                style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 14px; color: #5E5E5E; line-height: 1.5;",
                "Grup de Treball d'Indicadors de Salut per ABS, format per:"
              ),
              tags$ul(
                style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 14px; color: #5E5E5E; line-height: 1.5; padding-left: 20px;",
                tags$li("Agència de Salut Pública de Catalunya (ASPCAT)."),
                tags$li("Observatori del Sistema de Salut de Catalunya (OSSC), Agència de Qualitat i Avaluació sanitàries de Catalunya (AQuAS)."),
                tags$li("Direcció General de Planificació en Salut, Departament de Salut."),
                tags$li("Secretaria General, Departament de Salut.")
              ),
              p(
                style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 14px; color: #5E5E5E; line-height: 1.5;",
                "Amb la col·laboració de l'Institut Català de la Salut (ICS) i l'Idescat."
              )
            )
          ),
          
          br(),
          
          # Edicions
          card(
            card_header(
              h2("Edicions", 
                 style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 24px; color: #5EAEFF; background-color: white; 
                 text-align: left; margin-top: 0px; padding: 0px;")
            ),
            card_body(
              tags$ul(
                style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 14px; color: #5E5E5E; line-height: 1.5; padding-left: 20px;",
                tags$li("1a edició: Barcelona maig 2018."),
                tags$li("2a edició: Barcelona abril 2021."),
                tags$li("3a edició: Barcelona desembre 2024.")
              )
            )
          ),
          
          br(),
          
          # Assessorament lingüístic
          card(
            card_header(
              h2("Assessorament lingüístic", 
                 style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 24px; color: #5EAEFF; background-color: white; 
                 text-align: left; margin-top: 0px; padding: 0px;")
            ),
            card_body(
              p(
                style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 14px; color: #5E5E5E; line-height: 1.5;",
                "Servei de Planificació Lingüística del Departament de Salut."
              )
            )
          ),
          
          br(),
          
          # URL
          card(
            card_header(
              h2("URL", 
                 style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 24px; color: #5EAEFF; background-color: white; 
                 text-align: left; margin-top: 0px; padding: 0px;")
            ),
            card_body(
              p(
                tags$a(
                  href = "http://observatorisalut.gencat.cat/ca/observatori-desigualtats-salut/indicadors_comunitaria/",
                  target = "_blank", "http://observatorisalut.gencat.cat/ca/observatori-desigualtats-salut/indicadors_comunitaria/",
                  style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 14px; color: #5E5E5E; line-height: 1.5;",
                  title = "Pàgina web Indicadors de salut comunitària"
                )
              )
            )
          )
        )
      ),
      
      # Pestanya 'Dades'
      tabPanel(
        # Títol de la pestanya
        title = tagList(icon("table", style = "font-size: 18px;"), 
                        span("Dades", 
                             style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 18px; color: #5E5E5E;")), 
        
        # Estructura amb fila fluida
        fluidRow(
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 15px; margin-right: 0px;",
          column(
            width = 4,
            selectInput(
              inputId = "filtre_abs",
              label = HTML("<span style='font-family: \"Helvetica Now Display\", sans-serif; font-style: bold; 
                           font-size: 24px; color: #5EAEFF;'>Àrees bàsiques de salut (ABS)</span>"),
              choices = c("Totes", unique(df$ABS)),
              selected = "Totes",
              width = "100%"
            )
          ),
          column(
            width = 4,
            selectInput(
              inputId = "filtre_ambits",
              label = HTML("<span style='font-family: \"Helvetica Now Display\", sans-serif; font-style: bold; 
                           font-size: 24px; color: #5EAEFF;'>Àmbits</span>"),
              choices = c("Tots", unique(df$Àmbit)),
              selected = "Tots",
              width = "100%"
            )
          ),
          column(
            width = 4,
            selectInput(
              inputId = "filtre_indicadors",
              label = HTML("<span style='font-family: \"Helvetica Now Display\", sans-serif; font-style: bold; 
                           font-size: 24px; color: #5EAEFF;'>Indicadors</span>"),
              choices = c("Tots", unique(df$Indicador)),
              selected = "Tots",
              width = "100%"
            )
          )
        ),
        
        # Estructura amb fila fluida
        fluidRow(
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 15px; margin-right: 0px;",
          column(
            width = 12,
            dataTableOutput("taula_indicadors")
          )
        )
      ),
      
      # Pestanya 'Anàlisi'
      tabPanel(
        # Títol de la pestanya
        title = tagList(icon("chart-bar", style = "font-size: 18px;"), 
                        span("Anàlisi", 
                             style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 18px; color: #5E5E5E;")), 
        
        # Estructura amb files fluides
        fluidRow(
          style = "margin: 20px;",
          column(
            width = 12,
            card(
              card_header(
                h1("Anàlisi exploratòria de dades", 
                   style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 36px; color: #5EAEFF; 
             background-color: white; text-align: left; margin-top: 0px; padding: 0px;")
              ),
              card_body(
                p(
                  style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 16px; color: #5E5E5E; text-align: justify; line-height: 1.5;",
                  HTML("En aquesta secció podeu explorar les dades de manera interactiva mitjançant 
           <a href='https://github.com/Kanaries/GWalkR' title='GitHub del paquet GWalkR' style='color: #5E5E5E; text-decoration: underline;'>GWalkR</a>, 
           un paquet de R que permet analitzar les dades mitjançant operacions senzilles d'arrossegar i deixar anar. 
           A la pestanya <code style='color: #5E5E5E;'>Visualization</code>, podeu filtrar les dades i relacionar variables per generar gràfics personalitzats. 
           Per exemple, podeu arrossegar la variable <code style='color: #5E5E5E;'>Indicador</code> a <code style='color: #5E5E5E;'>Filters</code> i seleccionar el valor 
           <code style='color: #5E5E5E;'>Població assignada de 0-14 anys</code>. A continuació, arrossegueu les variables <code style='color: #5E5E5E;'>ABS</code> i 
           <code style='color: #5E5E5E;'>ABS homes</code> a <code style='color: #5E5E5E;'>X-Axis</code> i <code style='color: #5E5E5E;'>Y-Axis</code>, respectivament. 
           Així podreu generar un gràfic de barres que permet comparar diferents àrees bàsiques de salut en termes de població assignada en un grup d'edat determinat."
                  )
                )
              )
            )
          )
        ),
        
        # Estructura amb files fluides
        fluidRow(
          style = "margin: 20px;",
          column(
            width = 12,
            gwalkrOutput("analisi_exploratoria_dades_eda")
          )
        )
      ),
      
      # Pestanya 'Fitxes'
      tabPanel(
        # Títol de la pestanya
        title = tagList(icon("file-alt", style = "font-size: 18px;"), 
                        span("Fitxes", 
                             style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 18px; color: #5E5E5E;")), 
        
        # Estructura amb fila fluida
        fluidRow(
          style = "margin: 20px;",
          column(
            width = 12,
            card(
              card_header(
                h1("Fitxes metodològiques", 
                   style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 36px; color: #5EAEFF; 
             background-color: white; text-align: left; margin-top: 0px; padding: 0px;")
              ),
              card_body(
                p(
                  style = "font-family: 'Helvetica Now Display', sans-serif; font-size: 16px; color: #5E5E5E; text-align: justify; line-height: 1.5;",
                  "En aquesta secció podeu consultar les fitxes metodològiques dels indicadors de salut comunitària, 
                  elaborades per l'Agència de Qualitat i Avaluació Sanitàries de Catalunya (AQuAS). Cada fitxa inclou 
                  informació detallada com la descripció de l'indicador, la fórmula de càlcul, els criteris d'inclusió 
                  i exclusió, les dimensions de desagregació, l'origen de les dades i altres notes metodològiques 
                  rellevants. Per accedir al contingut complet d'una fitxa, seleccioneu-la al menú desplegable."
                )
              )
            )
          )
        ),
        
        # Estructura amb fila fluida
        fluidRow(
          style = "margin: 20px;",
          column(
            width = 3,
            selectInput(
              inputId = "filtre_fitxes",
              label = HTML("<span style='font-family: \"Helvetica Now Display\", sans-serif; font-style: bold; 
                     font-size: 24px; color: #5EAEFF;'>Selecciona una fitxa</span>"),
              choices = c(
                "Població assignada" = "SCDE01_fitxa_poblacio_assignada",
                "Visites a l'atenció primaria" = "SCMO01_SCMO02_visites_atencio_primaria",
                "Població atesa en un centre de salut mental d'adults (CSMA)" = "SCRE05_fitxa_poblacio_atesa_CSMA",
                "Consumidors de fàrmacs" = "SCRE06_fitxa_consumidors_farmacs",
                "Pacients polimedicats amb més de 10 principis actius" = "SCRE08_fitxa_pacients_polimedicats"
              ),
              selected = "SCDE01_fitxa_poblacio_assignada",
              width = "100%"
            )
          ),
          column(
            width = 9,
            uiOutput("fitxa_seleccionada")
          )
        )
      )
      
    )
  )
)

################################################################################

# Servidor
server <- function(input, output, session) {
  
  # Funció per anar a la pestanya 'Inici' des de la capçalera superior
  observeEvent(input$anar_pestanya_inici, { 
    updateTabsetPanel(session, "tabs", selected = "tab_inici") 
  })
  
  # Renderitzar la taula d'indicadors
  output$taula_indicadors <- renderDataTable({
    
    # Filtrar el dataframe per ABS, Àmbits i Indicadors
    df_filtrat <- df
    
    if (input$filtre_abs != "Totes") {
      df_filtrat <- subset(df_filtrat, ABS == input$filtre_abs)
    }
    
    if (input$filtre_ambits != "Tots") {
      df_filtrat <- subset(df_filtrat, Àmbit == input$filtre_ambits)
    }
    
    if (input$filtre_indicadors != "Tots") {
      df_filtrat <- subset(df_filtrat, Indicador == input$filtre_indicadors)
    }
    
    # Crear nom base per als arxius d'exportació
    nom_arxiu <- paste0("indicadors_salut_abs_", 
                        ifelse(input$filtre_abs == "Totes", 
                               "totes", 
                               tolower(gsub(" ", "_", 
                                            gsub("-", "", 
                                                 gsub(" - ", " ",
                                                      iconv(input$filtre_abs, 
                                                            to = "ASCII//TRANSLIT")))))))
    
    # Crear una taula interactiva amb les opcions definides
    datatable(
      df_filtrat,
      extensions = 'Buttons',
      rownames = FALSE,
      options = list(
        autoWidth = FALSE,
        pageLength = nrow(df_filtrat),
        lengthMenu = list(
          c(10, 25, 50, 100, 500, 1000, -1), 
          c(10, 25, 50, 100, 500, 1000, "Tots")
        ),
        dom = 'Bflrtip',
        initComplete = JS("function(settings, json) {
          // Estil 1a fila taula dades
          $(this.api().table().header()).css({
            'background-color': '#5EAEFF',
            'color': 'white'
          });
      
          // Espai vertical elements
          $('.dt-buttons').css('margin-bottom', '25px');
          $('.dataTables_length').css('margin-bottom', '25px');
          $('.dataTables_filter').css('margin-bottom', '25px');
      
          // Posició selector longitud i barra cerca
          $('.dt-buttons').css('float', 'left');
          $('.dataTables_filter').css({
            'float': 'right',
            'margin-left': '40px'
          });
          $('.dataTables_length').css({
            'float': 'right',
            'margin-left': '20px'
          });
      
          // Amplada selector longitud
          $('.dataTables_length select').css({
            'width': '60px'
          });
          
          // Aplicar font-family a tots els elements
          $('.dataTables_wrapper').css('font-family', '\"Helvetica Now Display\", sans-serif');
          
          // Color botons paginació
          $('<style>')
          .prop('type', 'text/css')
          .html(`
            .paginate_button:hover:not(.disabled):not(.active) {
              background: #5EAEFF !important;
              border-color: #949292 !important;
              color: #333333 !important;
            }
            
          `)
          .appendTo('head');
        }"),
        headerCallback = JS("function(thead, data, start, end, display) {
          // Línia capçalera
          $('th', thead).css('border-top', '1px solid #5d64a3');
        }"),
        buttons = list(
          list(
            extend = "copy", 
            text = "Còpia",
            titleAttr = "Copiar les dades de la taula al portapapers",
            title = NULL,
            exportOptions = list(
              orthogonal = 'export'
            )
          ),
          list(
            extend = "csv", 
            text = "CSV",
            titleAttr = "Exportar les dades de la taula en format CSV",
            filename = nom_arxiu,
            title = NULL,
            exportOptions = list(
              charset = "UTF-8",
              orthogonal = 'export'
            ),
            customize = JS("function(csv) {
              return '\ufeff' + csv;
            }")
          ),
          list(
            extend = "excel", 
            text = "XLSX",
            titleAttr = "Exportar les dades de la taula en format XLSX (Excel)",
            filename = nom_arxiu,
            title = NULL,
            exportOptions = list(
              orthogonal = 'export'
            )
          ),
          list(
            extend = "pdf", 
            text = "PDF vertical",
            titleAttr = "Exportar les dades de la taula en format PDF amb orientació vertical",
            filename = nom_arxiu,
            title = NULL,
            orientation = "portrait"
          ),
          list(
            extend = "pdf", 
            text = "PDF horitzontal",
            titleAttr = "Exportar les dades de la taula en format PDF amb orientació horitzontal",
            filename = nom_arxiu,
            title = NULL,
            orientation = "landscape"
          ),
          list(
            extend = "print", 
            text = "Imprimeix",
            titleAttr = "Imprimir les dades de la taula",
            title = "",
            messageTop = NULL,
            messageBottom = NULL
          )
        ),
        language = list(
          search = "<i class='glyphicon glyphicon-search'></i>",
          lengthMenu = "Mostra _MENU_ registres",
          info = "Regitres _START_ a _END_ de _TOTAL_ disponibles",
          infoEmpty = "No hi ha registres disponibles",
          thousands = ".",
          infoFiltered = "(filtrat de _MAX_ registres en total)",
          paginate = list(
            first = "Primer",
            last = "Últim",
            `next` = "Següent",
            previous = "Anterior"
          ),
          zeroRecords = "No s'han trobat registres coincidents",
          emptyTable = "No hi ha dades disponibles a la taula",
          buttons = list(
            copyTitle = 'Copiat al portapapers',
            copySuccess = list(
              `_` = '%d files copiades',
              `1` = '1 fila copiada'
            )
          )
        ),
        columnDefs = list(
          list(className = 'dt-left', targets = 0:2), 
          list(className = 'dt-center', targets = 3:8),
          list(
            targets = 3:8,
            render = JS("function(data, type, row) {
              if (type === 'export') {
                return data;
              }
              if (type === 'display') {
                return new Intl.NumberFormat('es-ES', {
                  minimumFractionDigits: 0,
                  maximumFractionDigits: 2,
                  useGrouping: true
                }).format(data);
              }
              return data;
            }")
          )
        )
      )
    )
  })
  
  # Anàlisi exploratòria de dades (EDA) amb GWalkR
  output$analisi_exploratoria_dades_eda = renderGwalkr(
    gwalkr(df)
  )
  
  # Renderitzar imatge fitxa seleccionada
  output$fitxa_seleccionada <- renderUI({
    imatge_url <- switch(input$filtre_fitxes,
                         "SCDE01_fitxa_poblacio_assignada" = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/SCDE01_fitxa_poblacio_assignada.png",
                         "SCMO01_SCMO02_visites_atencio_primaria" = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/SCMO01_SCMO02_visites_atencio_primaria.png",
                         "SCRE05_fitxa_poblacio_atesa_CSMA" = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/SCRE05_fitxa_poblacio_atesa_CSMA.png",
                         "SCRE06_fitxa_consumidors_farmacs" = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/SCRE06_fitxa_consumidors_farmacs.png",
                         "SCRE08_fitxa_pacients_polimedicats" = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/SCRE08_fitxa_pacients_polimedicats.png"
    )
    
    tags$img(
      src = imatge_url,
      style = "max-width: 100%; height: auto;"
    )
  })
  
}

################################################################################

# Execució
shinyApp(ui = ui, server = server)
