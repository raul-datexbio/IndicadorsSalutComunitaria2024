# Carregar llibreries
library(bslib)
library(DT)
library(GWalkR)
library(readr)
library(shiny)
library(shinyjs)
library(shinythemes)

# Carregar CSV (df = dataframe)
df <- read.csv('https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/Indicadors_ABS.csv',
               sep = ",", encoding = "latin1", check.names = FALSE)

################################################################################

# Interfície d'usuari de la Shiny app
ui <- fluidPage(
  
  # Activar Shinyjs
  useShinyjs(),
  
  # Tema
  theme = shinytheme("paper"),
  
  # Adaptació interfície a diferents dispositius
  responsive = TRUE,
  
  # Títol a la pestanya del navegador
  title = "Indicadors de Salut Comunitària",
  
  # Títol a la interfície
  titlePanel(
    div(
      style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 48px; color: #5EAEFF; 
      background-color: white; text-align: left; margin-top: 80px; padding: 20px;",
      "Indicadors de Salut Comunitària – 3a edició")
  ),
  
  # Panell de capçalera
  headerPanel(
    div(
      style = "position: fixed; top: 0; left: 0; right: 0; display: flex; justify-content: space-between; padding: 10px; 
               background-color: #5EAEFF; z-index: 10;",
      
      # Contenidor lateral esquerra: logotip
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
      
      # Contenidor lateral dret: icones
      div(
        style = "display: flex; align-items: center; gap: 15px; margin-right: 20px;",
        actionLink(
          inputId = "anar_pestanya_inici", 
          label = icon("home"), 
          style = "font-size: 20px; color: white; text-decoration: none;",
          title = "Anar a l'inici"
        ),
        actionLink(
          inputId = "anar_baix",
          label = icon("arrow-down"),
          style = "font-size: 20px; color: white; text-decoration: none;",
          title = "Anar a baix"
        ),
        actionLink(
          inputId = "anar_dalt",
          label = icon("arrow-up"),
          style = "font-size: 20px; color: white; text-decoration: none;",
          title = "Anar a dalt"
        ),
        tags$a(
          href = "https://ovt.gencat.cat/gsitfc/AppJava/generic/conqxsGeneric.do?webFormId=391&topicLevel1.id=1523&set-locale=ca_ES",
          target = "_blank",
          icon("envelope"),
          style = "font-size: 20px; color: white; text-decoration: none;",
          title = "Bústia de contacte"
        )
      )
    )
  ),
  
  # Funcionalitat de desplaçament suau cap amunt i cap avall
  tags$script('
  $(document).ready(function() {
    window.js = {
      scrollToBottom: function() {
        $("html, body").animate({ scrollTop: $(document).height() }, "smooth");
      },
      scrollToTop: function() {
        $("html, body").animate({ scrollTop: 0 }, "smooth");
      }
    };
  });
'),
  
  # Peu de pàgina
  tags$footer(
    style = "position: fixed; bottom: 0; left: 0; right: 0; padding: 5px; background-color: #f8f9fa; 
             border-top: 1px solid #5EAEFF; font-size: 16px; z-index: 10;", 
    
    # Contenidor principal
    div(
      style = "display: flex; justify-content: space-between; ",
      
      # Contenidor lateral esquerra: llicència
      div(
        style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; color: #5EAEFF; margin-left: 20px;", 
        HTML("© 2024, 
         <a href='https://web.gencat.cat/ca/inici' target='_blank' style='color: #5EAEFF;' title='Pàgina web de la Generalitat de Catalunya'>Generalitat Catalunya</a>,
         <a href='https://salutweb.gencat.cat/ca/inici' target='_blank' style='color: #5EAEFF;' title='Pàgina web del Departament de Salut'>Departament de Salut</a>,
         <a href='https://creativecommons.org/licenses/by-nc-nd/4.0/deed.ca' target='_blank' style='color: #5EAEFF;' title='Informació sobre la llicència CC BY-NC-ND 4.0'>CC BY-NC-ND 4.0</a>")
      ),
      
      # Contenidor lateral dret: xarxes socials
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
          title = "Butlletins de salut"
        ),
        tags$a(
          href = "https://canalsalut.gencat.cat/ca/actualitat/xarxes-socials/",
          target = "_blank",
          icon("share-nodes"),
          style = "color: #5EAEFF; font-size: 16px;",
          title = "Xarxes socials"
        )
      )
    )
  ),
  
  # Estils dels selectInput
  tags$head(
    tags$style(HTML("
    
    /* Estil selectInput */
    .selectize-dropdown .active {
      background: #5EAEFF !important;
      color: white !important;
    }
    .selectize-dropdown-content .option:hover {
      background: #5EAEFF !important;
      color: white !important;
    }
    
    /* Estil encapçalat nivell 1 */
    .header-level1-style {
        font-family: 'Helvetica Now Display', sans-serif;
        font-style: bold;
        font-size: 36px;
        color: #5EAEFF;
        background-color: white;
        text-align: left;
        margin-top: 0px; 
        padding: 0px;
    }
    
    /* Estil encapçalat nivell 2 */
    .header-level2-style {
        font-family: 'Helvetica Now Display', sans-serif;
        font-style: bold;
        font-size: 24px;
        color: #5EAEFF;
        background-color: white;
        text-align: left;
        margin-top: 0px; 
        padding: 0px;
    }
    
    /* Estil paràgraf nivell 1*/
    .paragraph-level1-style {
        font-family: 'Helvetica Now Display', sans-serif;
        font-size: 16px;
        color: #5E5E5E;
        text-align: justify;
        line-height: 1.5;
    }
      
    /* Estil paràgraf nivell 2*/
    .paragraph-level2-style {
        font-family: 'Helvetica Now Display', sans-serif;
        font-size: 14px;
        color: #5E5E5E;
        text-align: justify;
        line-height: 1.5;
    }
    
    /* Estil fórmules matemàtiques */
      .formula-container {
        display: flex;
        align-items: center;
        font-family: 'Helvetica Now Display', sans-serif;
        font-size: 14px;
        color: #5E5E5E;
      }
      .fraction {
        display: inline-block;
        vertical-align: middle;
        margin: 0 5px 0 0;
      }
      .fraction-top {
        border-bottom: 1px solid #5E5E5E;
        padding: 0 5px;
        text-align: center;
      }
      .fraction-bottom {
        padding: 0 5px;
        text-align: center;
      }
      
  "))
  ),
  
  # Panell principal
  mainPanel(
    style = "margin-top: -40px; margin-bottom: 100px; margin-right: 0px; margin-left: 0px; width: 100%;",
    
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
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 15px; margin-right: 0px;",
          
          # Presentació
          card(
            card_header(
              h1("Presentació", 
                 class = "header-level1-style")
            ),
            card_body(
              div(
                class = "paragraph-level1-style",
                p("Per desplegar l'orientació comunitària és essencial comptar amb dades fiables i robustes per àrees petites, que permetin una 
                  primera aproximació al diagnòstic comunitari."),
                p("En el marc del Pla de Salut de Catalunya, s’han seleccionat i calculat un conjunt d’indicadors bàsics a nivell d'Àrees Bàsiques de
                  Salut (ABS), seguint el marc conceptual dels determinants socials de la salut."),
                p(HTML("Per donar suport a aquest projecte, s'ha desenvolupat l’aplicació web interactiva <b>Indicadors de Salut Comunitària</b>, 
                  creada mitjançant el paquet <a href='https://shiny.posit.co/' target='_blank' title='Pàgina web de Shiny' style='color: #5E5E5E; text-decoration: underline;'>Shiny</a> de R.
                  Aquesta eina està pensada per facilitar la consulta, l'anàlisi i l’exportació intuïtiva de les dades disponibles sobre indicadors 
                  bàsics de salut comunitària per ABS de l’any 2022 a Catalunya.")),
                p("L’aplicació s’organitza en quatre pestanyes principals per optimitzar-ne l’ús:"),
                tags$ul(
                  style = "list-style-type: disc; padding-left: 20px;",
                  tags$li(HTML("<b>Inici</b>: introducció al projecte i informació clau.")),
                  tags$li(HTML("<b>Dades</b>: taula interactiva per consultar, filtrar i exportar dades.")),
                  tags$li(HTML("<b>Anàlisi</b>: eina per crear visualitzacions personalitzades.")),
                  tags$li(HTML("<b>Fitxes</b>: detall metodològic de cada indicador."))
                )
              )
            )
          ),
          
          # Separador
          div(
            style = "border-top: 1px solid #CCCCCC; margin: 30px 0;",
          ),
          
          # Autoria
          card(
            card_header(
              h2("Autoria", 
                 class = "header-level2-style",
                 style = "margin-top: 10px;")
            ),
            card_body(
              p(
                class = "paragraph-level2-style",
                "Grup de Treball d'Indicadors de Salut per ABS, format per:"
              ),
              tags$ul(
                class = "paragraph-level2-style",
                style = "padding-left: 20px;",
                tags$li("Agència de Salut Pública de Catalunya (ASPCAT)."),
                tags$li("Observatori del Sistema de Salut de Catalunya (OSSC), Agència de Qualitat i Avaluació sanitàries de Catalunya (AQuAS)."),
                tags$li("Direcció General de Planificació en Salut, Departament de Salut."),
                tags$li("Secretaria General, Departament de Salut.")
              ),
              p(
                class = "paragraph-level2-style",
                "Amb la col·laboració de l'Institut Català de la Salut (ICS) i l'Idescat."
              )
            )
          ),
          
          br(),
          
          # Edicions
          card(
            card_header(
              h2("Edicions", 
                 class = "header-level2-style")
            ),
            card_body(
              tags$ul(
                class = "paragraph-level2-style",
                style = "padding-left: 20px; margin-bottom: 0px",
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
                 class = "header-level2-style")
            ),
            card_body(
              p(
                class = "paragraph-level2-style",
                "Servei de Planificació Lingüística del Departament de Salut."
              )
            )
          ),
          
          br(),
          
          # URL
          card(
            card_header(
              h2("URL", 
                 class = "header-level2-style")
            ),
            card_body(
              p(
                tags$a(
                  href = "http://observatorisalut.gencat.cat/ca/observatori-desigualtats-salut/indicadors_comunitaria/",
                  target = "_blank", "http://observatorisalut.gencat.cat/ca/observatori-desigualtats-salut/indicadors_comunitaria/",
                  class = "paragraph-level2-style",
                  title = "Pàgina web del projecte Indicadors de Salut Comunitària"
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
        
        # Estructura amb fila fluida: text
        fluidRow(
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 0px; margin-right: 0px;",
          column(
            width = 12,
            card(
              card_header(
                h1("Taula de dades", 
                   class = "header-level1-style")
              ),
              card_body(
                p(
                  class = "paragraph-level1-style",
                  "En aquesta pestanya, podeu interactuar amb una taula que conté dades sobre diversos indicadors bàsics de salut comunitària per ABS de l'any 2022
                  a Catalunya. Les dades d'aquesta taula interactiva es poden ordenar, filtrar, cercar i exportar en diferents formats."
                )
              )
            )
          )
        ),
        
        # Separador
        div(
          style = "border-top: 1px solid #CCCCCC; margin: 30px 0;",
        ),
        
        # Estructura amb fila fluida: filtres
        fluidRow(
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 0px; margin-right: 0px;",
          column(
            width = 4,
            selectInput(
              inputId = "filtre_abs",
              label = HTML("<span style='font-family: \"Helvetica Now Display\", sans-serif; font-style: bold; 
                           font-size: 24px; color: #5EAEFF;'>Àrees bàsiques de salut</span>"),
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
        
        # Estructura amb fila fluida: taula de dades
        fluidRow(
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 0px; margin-right: 0px;",
          column(
            width = 12,
            dataTableOutput("taula_dades")
          )
        )
      ),
      
      # Pestanya 'Anàlisi'
      tabPanel(
        # Títol de la pestanya
        title = tagList(icon("chart-column", style = "font-size: 18px;"), 
                        span("Anàlisi", 
                             style = "font-family: 'Helvetica Now Display', sans-serif; font-style: bold; font-size: 18px; color: #5E5E5E;")), 
        
        # Estructura amb files fluides: text
        fluidRow(
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 0px; margin-right: 0px;",
          column(
            width = 12,
            card(
              card_header(
                h1("Anàlisi exploratòria de dades", 
                   class = "header-level1-style")
              ),
              card_body(
                div(
                  class = "paragraph-level1-style",
                  p(
                    HTML("En aquesta pestanya, podeu analitzar de manera interactiva les dades dels indicadors bàsics de salut comunitària per ABS de l'any 2022 a Catalunya utilitzant
                    <a href='https://github.com/Kanaries/GWalkR' target='_blank' title='GitHub del paquet GWalkR' style='color: #5E5E5E; text-decoration: underline;'>GWalkR</a>. 
                    Aquest és un paquet de R que facilita l'anàlisi exploratòria de dades (Exploratory Data Analysis, EDA) mitjançant una interfície intuïtiva basada 
                    en l'arrossegar i deixar anar variables als camps disponibles.")
                  ),
                  p(
                    HTML("A la pestanya <code style='color: #5E5E5E;'>Visualization</code>, podeu filtrar les dades i establir relacions entre variables per generar gràfics personalitzats. 
                    Per exemple, arrossegueu la variable <code style='color: #5E5E5E;'>Indicador</code> al camp <code style='color: #5E5E5E;'>Filters</code> i seleccioneu només el valor 
                    <code style='color: #5E5E5E;'>Població assignada de 0-14 anys</code>. A continuació, arrossegueu les variables <code style='color: #5E5E5E;'>ABS</code> i 
                    <code style='color: #5E5E5E;'>ABS homes</code> als camps <code style='color: #5E5E5E;'>X-Axis</code> i <code style='color: #5E5E5E;'>Y-Axis</code>, respectivament. 
                    Finalment, feu clic als botons <code style='color: #5E5E5E;'>Aggregation</code> i <code style='color: #5E5E5E;'>Sort in Descending Order</code>, situats a la barra d'eines superior,
                    per ordenar les ABS de major a menor població assignada d'homes de 0 a 14 anys en el gràfic de barres generat.")
                  )
                )
              )
            )
          )
        ),
        
        # Separador
        div(
          style = "border-top: 1px solid #CCCCCC; margin: 30px 0;",
        ),
        
        # Estructura amb files fluides: GWalkR
        fluidRow(
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 0px; margin-right: 0px;",
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
        
        # Estructura amb fila fluida: text
        fluidRow(
          style = "margin-top: 20px; margin-bottom: 20px; margin-left: 0px; margin-right: 0px;",
          column(
            width = 12,
            card(
              card_header(
                h1("Fitxes metodològiques", 
                   class = "header-level1-style")
              ),
              card_body(
                p(
                  class = "paragraph-level1-style",
                  "En aquesta pestanya, podeu consultar les fitxes metodològiques dels Indicadors de Salut Comunitària, 
                  desenvolupades per l'Agència de Qualitat i Avaluació Sanitàries de Catalunya (AQuAS). Cada fitxa proporciona
                  informació detallada sobre la descripció de l'indicador, la fórmula de càlcul, els criteris d'inclusió 
                  i exclusió, les dimensions de desagregació, l'origen de les dades i altres comentaris o notes metodològiques 
                  d'interès. Per accedir al contingut complet d'una fitxa, només cal que la seleccioneu al menú desplegable."
                )
              )
            )
          )
        ),
        
        # Separador
        div(
          style = "border-top: 1px solid #CCCCCC; margin: 30px 0;",
        ),
        
        # Estructura amb fila fluida: filtre
        div(
          style = "border: 1px solid #CCCCCC; border-radius: 12px; padding: 20px; background-color: #FFFFFF;",
          fluidRow(
            style = "margin-top: 20px; margin-bottom: 20px; margin-left: 0px; margin-right: 0px;",
            column(
              width = 4,
              selectInput(
                inputId = "filtre_fitxes",
                label = h2("Indicador", 
                           class = "header-level2-style"),
                choices = c(
                  "Població assignada" = "fitxa_poblacio_assignada",
                  "Població de 18 anys i més atesa a centres ambulatoris de salut mental" = "fitxa_poblacio_atesa"
                ),
                selected = "fitxa_poblacio_assignada",
                width = "100%"
              )
            ),
            column(
              width = 8,
              uiOutput("fitxa_seleccionada")
            )
          )
        )
        
      )
    )
  )
)

################################################################################

# Servidor de la Shiny app
server <- function(input, output, session) {
  
  # Funció 'Anar a l'inici' de la capçalera superior
  observeEvent(input$anar_pestanya_inici, { 
    updateTabsetPanel(session, "tabs", selected = "tab_inici") 
  })
  
  # Funció 'Anar a baix' de la capçalera superior
  observeEvent(input$anar_baix, {
    shinyjs::runjs('js.scrollToBottom()')
  }, ignoreInit = TRUE)
  
  #Funció 'Anar a dalt' de la capçalera superior
  observeEvent(input$anar_dalt, {
    shinyjs::runjs('js.scrollToTop()')
  }, ignoreInit = TRUE)
  
  # Generar i mostrar la taula de dades interactiva
  output$taula_dades <- renderDataTable({
    
    # Filtrar el dataframe per ABS, àmbits i indicadors
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
    
    # Definir les opcions de la taula
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
          // Estil 1a fila taula
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
            'width': '60px',
            'font-size': '14px'
          });
          
          // Aplicar font-family elements
          $('.dataTables_wrapper').css('font-family', '\"Helvetica Now Display\", sans-serif');
          
          // Color botons exportació i paginació
          $('<style>')
          .prop('type', 'text/css')
          .html(`
                /* Estil per als botons de paginació no actius quan es passa el cursor */
                .paginate_button:hover:not(.disabled):not(.current) {
                  background: #5EAEFF !important;
                  border-color: #949292 !important;
                  color: white !important;
                }
    
                /* Estil per al botó de paginació actiu sense passar el cursor */
                .paginate_button.current {
                  background: white !important;
                  border-color: #949292 !important;
                  color: #333333 !important;
                }
    
                /* Estil per al botó de paginació actiu quan es passa el cursor */
                .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover,
                .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover span {
                  background: #5EAEFF !important;
                  border-color: #949292 !important;
                  color: white !important;
                }
    
                /* Forçar el color blanc al text del botó actiu quan es passa el cursor */
                .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
                  background: #5EAEFF !important;
                  background-color: #5EAEFF !important;
                  color: white !important;
                }
                
                /* Estil per als botons d'exportació */
                .dt-button:hover {
                  background: #5EAEFF !important;
                  border-color: #949292 !important;
                  color: white !important;
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
            titleAttr = "Copiar la taula de dades al portapapers",
            title = NULL,
            exportOptions = list(
              orthogonal = 'export'
            )
          ),
          list(
            extend = "csv", 
            text = "CSV",
            titleAttr = "Exportar la taula de dades en format CSV",
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
            titleAttr = "Exportar la taula de dades en format XLSX (Excel)",
            filename = nom_arxiu,
            title = NULL,
            exportOptions = list(
              orthogonal = 'export'
            )
          ),
          list(
            extend = "pdf", 
            text = "PDF vertical",
            titleAttr = "Exportar la taula de dades en format PDF amb orientació vertical",
            filename = nom_arxiu,
            title = NULL,
            orientation = "portrait"
          ),
          list(
            extend = "pdf", 
            text = "PDF horitzontal",
            titleAttr = "Exportar la taula de dades en format PDF amb orientació horitzontal",
            filename = nom_arxiu,
            title = NULL,
            orientation = "landscape"
          ),
          list(
            extend = "print", 
            text = "Imprimeix",
            titleAttr = "Imprimir la taula de dades",
            title = "",
            messageTop = NULL,
            messageBottom = NULL
          )
        ),
        language = list(
          search = "<i class='glyphicon glyphicon-search'></i>",
          lengthMenu = "Mostrar _MENU_ registres",
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
  
  # Mostrar GWalkR
  output$analisi_exploratoria_dades_eda = renderGwalkr(
    gwalkr(df)
  )
  
  # Mostrar fitxa seleccionada
  output$fitxa_seleccionada <- renderUI({
    switch(input$filtre_fitxes,
           
           "fitxa_poblacio_assignada" = card(
             card_body(
               div(
                 class = "paragraph-level2-style",
                 h2("Descripció", class = "header-level2-style"),
                 p("Població assignada a un equip d'atenció primària (EAP) que ha estat assignada per aquest equip en l'any d'estudi."),
                 
                 h2("Fórmula", class = "header-level2-style"),
                 p("Població assignada a l'EAP."),
                 
                 h2("Origen de les dades", class = "header-level2-style"),
                 p("Registre central de persones assegurades (RCA). Servei Català de la Salut.")
               )
             )
           ),
           
           "fitxa_poblacio_atesa" = card(
             card_body(
               div(
                 class = "paragraph-level2-style",
                 h2("Descripció", class = "header-level2-style"),
                 p("Percentatge de la població de 18 anys o més que ha estat atesa per un centre de salut mental d'adults (CSMA)."),
                 
                 h2("Fórmula", class = "header-level2-style"),
                 div(
                   class = "formula-container",
                   div(
                     class = "fraction",
                     div(
                       class = "fraction-top",
                       "Nombre de persones de 18 anys o més amb el diagnòstic seleccionat ateses per un CSMA"
                     ),
                     div(
                       class = "fraction-bottom",
                       "Població de 18 anys o més"
                     )
                   ),
                   "× 100"
                 ),
                 
                 h2("Comentaris", class = "header-level2-style"),
                 p("L'indicador es calcula per territori de residència del pacient (àrea bàsica de salut i agrupacions superiors) i per CSMA. L'indicador per territori de residència del pacient té en compte l'activitat realitzada pels pacients a qualsevol centre, no únicament el seu centre de referència. L'indicador per CSMA només té en compte l'activitat que ha realitzat aquell centre amb la seva població de referència. La població de referència d'un CSMA és la població assignada als equips d'atenció primària que poden derivar pacients a aquest centre."),
                 
                 h2("Dimensions de desagregació", class = "header-level2-style"),
                 p("Per centre; per diagnòstics seleccionats (trastorn per esquizofrènia, trastorn depressiu, trastorn bipolar, altres trastorns de l'estat d'ànim, ansietat i trastorns de la por, trastorn obsessivocompulsiu, trastorns per traumes i estrès, trastorns de conducta, trastorns de la personalitat, trastorns de la conducta alimentària, trastorns somàtics, idees suïcides, trastorns de comportament, trastorns del neurodesenvolupament); per sexe; per grup d'edat."),
                 
                 h2("Origen de les dades", class = "header-level2-style"),
                 p("Registre del conjunt mínim bàsic de dades de salut mental (CMBD SM) i Registre Central d'Assegurats (RCA). Servei Català de la Salut (CatSalut).")
               )
             )
           )
    )
  })
  
}

################################################################################

# Execució de la Shiny app
shinyApp(ui = ui, server = server)
