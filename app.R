# Carregar llibreries
library(bslib)
library(DT)
library(dplyr)
library(gtools)
library(GWalkR)
library(readr)
library(shiny)
library(shinyjs)
library(shinythemes)

# Carregar CSV penstanya 'Dades'
df <- read.csv('https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/dades_indicadors_salut_comunitaria.csv',
               sep = ",", encoding = "latin1", check.names = FALSE)

# Carregar CSV penstanya 'Anàlisi'
df_gwalkr <- read.csv('https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/dades_indicadors_salut_comunitaria_gwalkr.csv',
               sep = ",", encoding = "latin1", check.names = FALSE)

################################################################################

# Interfície d'usuari de la Shiny app
ui <- tagList(
  
  # Activar shinyjs
  useShinyjs(),
  
  # Recursos addicionals i estils personalitzats 
  tags$head(
    
    # Bootstrap icons
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"),
    
    # CSS
    tags$style(HTML("
      
      /* Estils barra navegació */
      .navbar {
        border-bottom: 1px solid #CCCCCC;
        height: 70px;
        align-items: center;
      }
      
      /* Separar logotip de pestanyes */
      .navbar-brand {
        margin-right: 40px;
        margin-left: 10px; 
      }
      
      /* Estils pestanyes barra navegació */
      .navbar-nav .nav-link {
        color: #5E5E5E;
        font-size: 14px;
        padding: 10px 15px 10px 25px;
        margin-top: -7px; 
      }
      .navbar-nav .nav-link.active {
        color: #000000;
        position: relative;
      }
      .navbar-nav .nav-link:hover {
        background-color: #CCCCCC;
        color: #000000;
        cursor: pointer;
      }
      .nav-link i {
        margin-right: 6px;
      }
      
      /* Estil menú hamburguesa */
      @media (max-width: 1200px) {
        .navbar-collapse {
          background-color: #f8f9fa;
          opacity: 1;
          padding: 10px 30px 15px 30px;
          border-bottom: 1px solid #CCCCCC;
          position: absolute;
          top: 70px;
          left: 0;
          right: 0;
          bottom: auto;
          z-index: 1000;
          transition: all 0.5s linear;
        }
        .navbar-collapse.collapsing {
          opacity: 1;
        }
      }

      /* Estil títols */
      .title-style {
        font-style: bold;
        font-weight: 600;
        color: #000000;
      }
      
      /* Estil paràgraf*/
      .paragraph-style {
        font-size: 16px;
        color: #5E5E5E;
        text-align: justify;
        line-height: 1.5;
      }
      
      /* Estil botó primari */
      .action-button-primary {
        margin-top: 20px;
        color: white;
        background-color: #5EAEFF;
        border: none;
        border-radius: 20px;
        padding: 8px 16px;
        transition: background-color 0.3s;
      }
      .action-button-primary:hover {
        background-color: #1565C0;
      }
      
      /* Estil fórmules matemàtiques */
      .formula-container {
        display: flex;
        align-items: center;
        font-family: 'Helvetica Now Display', sans-serif;
        font-size: 16px;
        color: #5E5E5E;
        margin-bottom: 20px;
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
  
  # JavaScript
  tags$script('
  $(document).ready(function() {
    
    // Funcions menú hamburguesa
    function setMenuHeight() {
      const menuHeight = $(".navbar-collapse").height();
      document.documentElement.style.setProperty("--menu-height", menuHeight + "px");
    }
    setMenuHeight();
    $(window).resize(setMenuHeight);
    $(".navbar-nav .nav-link").on("click", function() {
      $(".navbar-collapse").collapse("hide");
    });
  });
'),
  
  page_navbar(
    
    # Idioma català
    lang = "ca",
    
    # Títol a la pestanya del navegador
    window_title = "Indicadors de Salut Comunitària",
    
    # Barra navegació fixa
    position = 'fixed-top',
    
    # Color fons barra navegació
    bg = "#f8f9fa",
    
    # Visualització dispositiu
    fillable = TRUE,
    fillable_mobile = TRUE,
    fluid = TRUE,
    
    # Disseny responsiu 
    collapsible = TRUE,
    
    # Títol i logotip
    title = tags$a(
      href = "https://aquas.gencat.cat/ca/inici/",
      target = "_blank",
      img(
        src = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/aquas_logotip.png",
        height = "30px",
        title = "Pàgina web d'AQuAS"
      )
    ),
    
    # Pestanya 'Inici'
    nav_panel(
      
      title = "Inici",
      icon = icon("home"),
      value = "tab_inici",
      
      # Títol aplicació
      div(
        style = "height: 60px; margin: 45px -24px 0px -24px; width: calc(100% + 48px); display: flex; align-items: center; justify-content: center;
                background: linear-gradient(135deg, #E3F2FD, #90CAF9); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
        h1(
          "Indicadors de Salut Comunitària",
          style = "color: #1565C0; font-style: bold; font-weight: 600; letter-spacing: 0.5px; margin: 0;"
        )
      ),
      
      br(),
      
      # Card Presentació
      div(
        style = "margin-top: -20px",
        card(

          card_header(
            div(
              style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
              icon("person-chalkboard", 
                   style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
              h2("Presentació", 
                 class = "title-style",
                 style = "margin: 0; padding: 0;")
            )
          ),
          card_body(
            div(
              class = "paragraph-style",
              p("Per desplegar l'orientació comunitària és essencial comptar amb dades fiables i robustes per àrees petites, que permetin una 
                primera aproximació al diagnòstic comunitari."),
              p("En el marc del Pla de Salut de Catalunya, s'han seleccionat i calculat un conjunt d'indicadors de salut comunitària a nivell d'àrees bàsiques de
                salut (ABS).")
            )
          )
        ),
        
        br(),
        
        # Cards Aplicació web i Estructura
        layout_column_wrap(
          width = 1/2,
          style = css(grid_gap = "14px"),
          
          # Card Aplicació web
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("desktop", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Aplicació web", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              p("Per donar suport a aquest projecte, s'ha desenvolupat una aplicació web interactiva mitjançant el paquet Shiny de R.",
                tags$a(
                  href = "https://shiny.posit.co/",
                  style = "margin-left: 5px;",
                  icon("arrow-up-right-from-square", style = "font-size: 16px; color: #5E5E5E;"),
                  title = "Pàgina web de Shiny",
                  target = "_blank"
                ),
              ),
              p("Aquesta aplicació està dissenyada per facilitar la consulta, l'anàlisi i l'exportació intuïtiva de les dades disponibles sobre indicadors 
                 de salut comunitària per ABS de Catalunya.")
            )
          ),
          
          # Card Estructura
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("sitemap", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Estructura", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              p("L'aplicació s'estructura en quatre pestanyes principals:"),
              tags$ul(
                style = "list-style-type: none; padding-left: 0;",
                tags$li(style = "margin-bottom: 10px;", icon("home", style = "color: #5E5E5E; margin-right: 10px;"), HTML("<b>Inici:</b> Introducció al projecte i informació clau.")),
                tags$li(style = "margin-bottom: 10px;", icon("table", style = "color: #5E5E5E; margin-right: 10px;"), HTML("<b>Dades:</b> Taula de dades amb les ABS i els indicadors seleccionats.")),
                tags$li(style = "margin-bottom: 10px;", icon("chart-column", style = "color: #5E5E5E; margin-right: 10px;"), HTML("<b>Anàlisi:</b> Eina per crear gràfics personalitzats.")),
                tags$li(style = "margin-bottom: -10px;", icon("file-alt", style = "color: #5E5E5E; margin-right: 10px;"), HTML("<b>Fitxes:</b> Fitxes metodològiques de cada indicador."))
              )
            )
          )
        ),
        
        br(),
        
        # Cards Autoria i Llicència
        layout_column_wrap(
          width = 1/2,
          style = css(grid_gap = "14px"),
          
          # Card Autoria
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("users", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Autoria", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              p("Grup de treball d'indicadors de salut per àrees bàsiques de salut, format per:"),
              tags$ul(
                style = "list-style-type: none; padding-left: 0;",
                tags$li(
                  style = "margin-bottom: 10px;",
                  style = "display: flex; align-items: flex-start; gap: 10px;",
                  icon("user-large", style = "color: #5E5E5E; min-width: 16px; margin-top: 4px;"),
                  "Agència de Salut Pública de Catalunya (ASPCAT)."
                ),
                tags$li(
                  style = "margin-bottom: 10px;",
                  style = "display: flex; align-items: flex-start; gap: 10px;",
                  icon("user-large", style = "color: #5E5E5E; min-width: 16px; margin-top: 4px;"),
                  "Observatori del Sistema de Salut de Catalunya (OSSC), Agència de Qualitat i Avaluació Sanitàries de Catalunya (AQuAS)."
                ),
                tags$li(
                  style = "margin-bottom: 10px;",
                  style = "display: flex; align-items: flex-start; gap: 10px;",
                  icon("user-large", style = "color: #5E5E5E; min-width: 16px; margin-top: 4px;"),
                  "Direcció General de Planificació en Salut, Departament de Salut."
                ),
                tags$li(
                  style = "margin-bottom: 5px;",
                  style = "display: flex; align-items: flex-start; gap: 10px;",
                  icon("user-large", style = "color: #5E5E5E; min-width: 16px; margin-top: 4px;"),
                  "Secretaria General, Departament de Salut."
                )
              ),
              p("Amb la col·laboració de l'Institut Català de la Salut (ICS) i l'Idescat.", style = "margin-top: -20px;")
            )
          ),
          
          # Card Llicència
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("creative-commons", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Llicència", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              p("© 2024, Generalitat de Catalunya. Departament de Salut."),
              p("Els continguts d'aquesta obra estan subjectes a una llicència de Reconeixement-NoComercial-SenseObraDerivada 4.0 Internacional."),
              div(
                style = "text-align: left;",
                a(
                  href = "http://creativecommons.org/licenses/by-nc-nd/4.0/deed.ca' target='_blank' title='Informació llicència",
                  target = "_blank",
                  img(src = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/llicencia_logotip.png",
                      height = "45px",
                      title = "Pàgina web de la llicència Creative Commons"
                  )
                )
              )
            )
          )
        ),
        
        br(),
        
        # Cards Edicions i Assessorament lingüístic
        layout_column_wrap(
          width = 1/2,
          style = css(grid_gap = "14px"),
          
          # Card Edicions
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("book-open", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Edicions", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              tags$ul(
                style = "list-style-type: none; padding-left: 0;",
                tags$li(style = "margin-bottom: 10px;", icon("calendar-day", style = "color: #5E5E5E; margin-right: 10px;"), HTML("<b>1a edició:</b> Barcelona maig 2018.")),
                tags$li(style = "margin-bottom: 10px;", icon("calendar-day", style = "color: #5E5E5E; margin-right: 10px;"), HTML("<b>2a edició:</b> Barcelona abril 2021.")),
                tags$li(style = "margin-bottom: -10px;", icon("calendar-day", style = "color: #5E5E5E; margin-right: 10px;"), HTML("<b>3a edició:</b> Barcelona desembre 2024."))
              )
            )
          ),
          
          # Card Assessorament lingüístic
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("language", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Assessorament lingüístic", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              p("Servei de Planificació Lingüística del Departament de Salut.")
            )
          )
        ),
        
        br(),
        
        # Cards Més informació i Contacte
        layout_column_wrap(
          width = 1/2,
          style = css(grid_gap = "14px"),
          
          # Card Més informació
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("circle-info", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Més informació",
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              span(
                "Observatori de Desigualtats en Salut > Indicadors de salut comunitària",
                tags$a(
                  href = "http://observatorisalut.gencat.cat/ca/observatori-desigualtats-salut/indicadors_comunitaria/",
                  style = "margin-left: 5px;",
                  icon("arrow-up-right-from-square", style = "font-size: 16px; color: #5E5E5E;"),
                  title = "Pàgina web del projecte Indicadors de salut comunitària",
                  target = "_blank"
                )
              )
            )
          ),
          
          # Card Contacte
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("envelope", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Contacte", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              span(
                "cdr.aquas@gencat.cat",
                tags$a(
                  href = "mailto:cdr.aquas@gencat.cat",
                  style = "margin-left: 5px;",
                  icon("paper-plane", style = "font-size: 16px; color: #5E5E5E;"),
                  title = "Adreça de correu electrònic AQuAS",
                  target = "_blank"
                )
              )
            )
          )
        ),
        
        br(),
        
        # Peu pàgina xarxes socials
        div(
          style = "background-color: #f8f9fa; padding: 15px 0; width: calc(100% + 48px); border-top: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; margin: 0 -24px;",
          div(
            style = "display: flex; justify-content: center; align-items: center; gap: 10px;",
            span(
              "Segueix-nos a les xarxes socials AQuAS:",
              style = "color: #5E5E5E; font-size: 15px; margin-right: 30px;"
            ),
            a(
              href = "https://x.com/AQuAScat",
              target = "_blank",
              img(
                src = "https://aquas.gencat.cat/web/resources/fwkResponsive/fpca_peu_xarxesSocials/img/twitter-c.svg",
                style = "height: 24px; width: 24px;"
              ),
              title = "Twitter",
              style = "text-decoration: none;"
            ),
            a(
              href = "https://www.linkedin.com/company/aquas-salut/",
              target = "_blank",
              img(
                src = "https://aquas.gencat.cat/web/resources/fwkResponsive/fpca_peu_xarxesSocials/img/linkedin-c.svg",
                style = "height: 24px; width: 24px;"
              ),
              title = "LinkedIn",
              style = "text-decoration: none;"
            ),
            a(
              href = "https://www.youtube.com/channel/UCLnTGcmpedzhLKkbIR-a0fw",
              target = "_blank",
              img(
                src = "https://aquas.gencat.cat/web/resources/fwkResponsive/fpca_peu_xarxesSocials/img/youtube-c.svg",
                style = "height: 24px; width: 24px;"
              ),
              title = "YouTube",
              style = "text-decoration: none;"
            ),
            a(
              href = "https://blog.aquas.cat/",
              target = "_blank",
              img(
                src = "https://aquas.gencat.cat/web/resources/fwkResponsive/fpca_peu_xarxesSocials/img/message-c.svg",
                style = "height: 24px; width: 24px;"
              ),
              title = "Blog",
              style = "text-decoration: none;"
            )
          )
        ),
        
        # Peu pàgina informació complementària
        div(
          style = "background-color: #333333; color: #FFFFFF; padding: 5px 0; width: calc(100% + 48px); margin: 0 -24px;",
          div(
            style = "display: flex; justify-content: space-between; align-items: center; padding: 0 24px;",
            div(
              a(
                img(
                  src = "https://raw.githubusercontent.com/raul-datexbio/IndicadorsSalutComunitaria2024/main/imatges/gencat_logotip.png",
                  height = "25px"
                ),
                href = "https://web.gencat.cat/",
                target = "_blank",
                title = "Pàgina web de la Generalitat de Catalunya"
              )
            ),
            div(
              style = "text-align: center; font-size: 10px;",
              "Agència de Qualitat i Avaluació Sanitàries de Catalunya, 2024"
            ),
            div(
              style = "text-align: right; font-size: 10px; display: flex; align-items: center; gap: 8px;",
              a(
                "Avís legal",
                href = "https://web.gencat.cat/ca/ajuda/avis_legal/",
                target = "_blank",
                style = "color: #FFFFFF; text-decoration: none;",
                onmouseover = "this.style.textDecoration='underline'",
                onmouseout = "this.style.textDecoration='none'",
                title = "Avís legal de la Generalitat de Catalunya"
              ),
              span(
                "|",
                style = "color: #FFFFFF;"
              ),
              a(
                "Política de galetes",
                href = "https://web.gencat.cat/ca/ajuda/politica-de-galetes/",
                target = "_blank",
                style = "color: #FFFFFF; text-decoration: none;",
                onmouseover = "this.style.textDecoration='underline'",
                onmouseout = "this.style.textDecoration='none'",
                title = "Política de galetes dels portals de la Generalitat de Catalunya"
              )
            )
          )
        )
        
      )
    ),
    
    # Pestanya 'Dades'
    nav_panel(
      title = "Dades",
      icon = icon("table"),
      value = "tab_dades",
      
      # Títol aplicació
      div(
        style = "height: 60px; margin: 45px -24px 0px -24px; width: calc(100% + 48px); display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, #E3F2FD, #90CAF9); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
        h1(
          "Indicadors de Salut Comunitària",
          style = "color: #1565C0; font-style: bold; font-weight: 600; letter-spacing: 0.5px; margin: 0;"
        )
      ),
      
      br(),
      
      # Estructura amb fila fluida: text
      fluidRow(
        style = "margin-top: -20px;",
        column(
          width = 12,
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("table", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Taula de dades", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              div(
                class = "paragraph-style",
                p("En aquesta pàgina, es pot visualitzar una taula de dades amb els indicadors de salut comunitària per àrees bàsiques de salut (ABS) de Catalunya."),
                p("Els selectors permeten mostrar les dades d'interès. És possible fer seleccions múltiples. La taula de dades resultant es pot exportar en diferents formats.")
              )
            )
          )
        )
      ),
      
      # Estructura amb fila fluida: selectors
      fluidRow(
        style = "margin-top: 0px;",
        column(
          width = 12,
          card(
            class = "overflow-visible",
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("list-check", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Selectors", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              style = "overflow: visible;",
              fluidRow(
                style = "margin: 0px;",
                column(
                  width = 6,
                  selectInput(
                    inputId = "select_rs",
                    label = div(
                      class = "paragraph-style",
                      icon("check", style = "color: #5E5E5E; margin-right: 10px;"), 
                      HTML("<b>Pas 1:</b> Selecciona les regions sanitàries")
                    ),
                    choices = c("Totes", mixedsort(as.character(unique(df$`Regió sanitària`)))),
                    selected = NULL,
                    multiple = TRUE,
                    width = "100%"
                  )
                ),
                column(
                  width = 6,
                  selectInput(
                    inputId = "select_abs",
                    label = div(
                      class = "paragraph-style",
                      icon("check", style = "color: #5E5E5E; margin-right: 10px;"), 
                      HTML("<b>Pas 2:</b> Selecciona les àrees bàsiques de salut")
                    ),
                    choices = c("Totes", mixedsort(as.character(unique(df$`Àrea bàsica de salut`)))),
                    selected = NULL,
                    multiple = TRUE,
                    width = "100%"
                  )
                ),
                column(
                  width = 6,
                  selectInput(
                    inputId = "select_ambits",
                    label = div(
                      class = "paragraph-style",
                      icon("check", style = "color: #5E5E5E; margin-right: 10px;"), 
                      HTML("<b>Pas 3:</b> Selecciona els àmbits")
                    ),
                    choices = c("Tots", mixedsort(as.character(unique(df$`Àmbit`)))),
                    selected = NULL,
                    multiple = TRUE,
                    width = "100%"
                  )
                ),
                column(
                  width = 6,
                  selectInput(
                    inputId = "select_indicadors",
                    label = div(
                      class = "paragraph-style",
                      icon("check", style = "color: #5E5E5E; margin-right: 10px;"), 
                      HTML("<b>Pas 4:</b> Selecciona els indicadors de salut comunitària")
                    ),
                    choices = c("Tots", mixedsort(as.character(unique(df$Indicador)))),
                    selected = NULL,
                    multiple = TRUE,
                    width = "100%"
                  )
                ),
                column(
                  width = 12,
                  style = "text-align: right;",
                  div(
                    style = "display: flex; justify-content: flex-end; gap: 10px;",
                    actionButton(
                      "apply_selection",
                      span(
                        tags$i(class = "fa fa-check", style = "margin-right: 5px;"), 
                        "Aplica la selecció"
                      ),
                      class = "action-button-primary",
                      title = "Aplica la selecció actual"
                    ),
                    actionButton(
                      "clear_selection",
                      span(
                        tags$i(class = "fa fa-eraser", style = "margin-right: 5px;"), 
                        "Neteja la selecció"
                      ),
                      class = "action-button-primary",
                      title = "Neteja la selecció actual"
                    )
                  )
                )
              )
            )
          )
        )
      ),
      
      # Estructura amb fila fluida: taula de dades
      fluidRow(
        style = "margin-top: 0px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px;",
        column(
          width = 12,
          uiOutput("taula_container")
        )
      )
    ),
    
    # Pestanya 'Anàlisi'
    nav_panel(
      title = "Anàlisi",
      icon = icon("chart-column"),
      value = "tab_analisi",
      
      # Títol aplicació
      div(
        style = "height: 60px; margin: 45px -24px 0px -24px; width: calc(100% + 48px); display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, #E3F2FD, #90CAF9); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
        h1(
          "Indicadors de Salut Comunitària",
          style = "color: #1565C0; font-style: bold; font-weight: 600; letter-spacing: 0.5px; margin: 0;"
        )
      ),
      
      br(),
      
      # Estructura amb files fluides: text
      fluidRow(
        style = "margin-top: -20px;",
        column(
          width = 12,
          # Card Anàlisi exploratòria de dades
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("chart-column", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Anàlisi exploratòria de dades", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              div(
                class = "paragraph-style",
                p(
                  "En aquesta pàgina, es poden analitzar de manera interactiva les dades dels indicadors de salut comunitària per àrees bàsiques de salut (ABS) de Catalunya utilitzant GWalkR.",
                  tags$a(
                    href = "https://github.com/Kanaries/GWalkR",
                    style = "margin-left: 5px;",
                    icon("github", style = "font-size: 16px; color: #5E5E5E;"),
                    title = "GitHub del paquet GWalkR",
                    target = "_blank"
                  ),
                ),
                p(
                  HTML("A la pestanya <code style='color: #5E5E5E;'>Visualization</code>, es pot filtrar les dades i establir relacions entre variables per generar gràfics personalitzats.")
                )
              )
            )
          )
        )
      ),
      fluidRow(
        style = "margin-top: 0px;",
        column(
          width = 12,
          # Card Exemple
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("person-chalkboard", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Exemple", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              class = "paragraph-style",
              tags$ul(
                style = "list-style-type: none; padding-left: 0;",
                tags$li(
                  style = "margin-bottom: 10px;",
                  icon("check", style = "color: #5E5E5E; margin-right: 10px;"),
                  HTML("<b>Pas 1:</b> Arrossega la variable <code style='color: #5E5E5E;'>Regió sanitària</code> al camp <code style='color: #5E5E5E;'>Filters</code>, 
                  fes clic al botó <code style='color: #5E5E5E;'>Unselect All</code> i selecciona només el valor 
                  <code style='color: #5E5E5E;'>Lleida</code>.")
                ),
                tags$li(
                  style = "margin-bottom: 10px;",
                  icon("check", style = "color: #5E5E5E; margin-right: 10px;"),
                  HTML("<b>Pas 2:</b> Arrossega la variable <code style='color: #5E5E5E;'>Indicador</code> al camp <code style='color: #5E5E5E;'>Filters</code>, 
                  fes clic al botó <code style='color: #5E5E5E;'>Unselect All</code> i selecciona només el valor 
                  <code style='color: #5E5E5E;'>Població assignada de 0-14 anys</code>.")
                ),
                tags$li(
                  style = "margin-bottom: 10px;",
                  icon("check", style = "color: #5E5E5E; margin-right: 10px;"),
                  HTML("<b>Pas 3:</b> Arrossega les variables <code style='color: #5E5E5E;'>Àrea bàsica de salut</code> i <code style='color: #5E5E5E;'>ABS homes</code> als camps 
                  <code style='color: #5E5E5E;'>X-Axis</code> i <code style='color: #5E5E5E;'>Y-Axis</code>, respectivament.")
                ),
                tags$li(
                  style = "margin-bottom: -10px;",
                  icon("check", style = "color: #5E5E5E; margin-right: 10px;"),
                  HTML("<b>Pas 4:</b> Fes clic als botons <code style='color: #5E5E5E;'>Aggregation</code>, <code style='color: #5E5E5E;'>Sort in Descending Order</code> 
                  i <code style='color: #5E5E5E;'>Layout Mode: Container</code>, situats en 3a, 8a i 10a posició a la barra d'eines superior,
                  per obtenir un gràfic de barres amb les ABS ordenades de major a menor població assignada d'homes de 0 a 14 anys.")
                )
              )
            )
          )
        )
      ),
      
      # Estructura amb files fluides: GWalkR
      fluidRow(
        style = "margin-top: 0px; margin-bottom: 0px; margin-left: 0px; margin-right: 0px;",
        column(
          width = 12,
          gwalkrOutput("analisi_exploratoria_dades_eda")
        )
      ),
      
      tags$div(style = "height: 10px;")
    ),
    
    # Pestanya 'Fitxes metodològiques'
    nav_panel(
      
      title = "Fitxes metodològiques",
      icon = icon("file-alt"),
      value = "tab_fitxes",
      
      # Títol aplicació
      div(
        style = "height: 60px; margin: 45px -24px 0px -24px; width: calc(100% + 48px); display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, #E3F2FD, #90CAF9); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
        h1(
          "Indicadors de Salut Comunitària",
          style = "color: #1565C0; font-style: bold; font-weight: 600; letter-spacing: 0.5px; margin: 0;"
        )
      ),
      
      br(),
      
      # Card Fitxes metodològiques
      fluidRow(
        style = "margin-top: -20px;",
        column(
          width = 12,
          card(
            card_header(
              div(
                style = "display: flex; align-items: center; gap: 15px; line-height: 1.5;",
                icon("file-alt", 
                     style = "color: #5EAEFF; font-size: 24px; display: flex; align-items: center;"),
                h2("Fitxes metodològiques", 
                   class = "title-style",
                   style = "margin: 0; padding: 0;")
              )
            ),
            card_body(
              div(
                class = "paragraph-style",
                p("En aquesta pàgina, es poden consultar les fitxes metodològiques dels indicadors de salut comunitària, desenvolupades per l'Agència de Qualitat i Avaluació Sanitàries de Catalunya (AQuAS)."),
                p("Cada fitxa proporciona informació detallada sobre la descripció de l'indicador, la fórmula de càlcul, els criteris tècnics, el període i l'origen de les dades."),
                p("Per accedir al contingut complet d'una fitxa determinada, només cal seleccionar l'indicador d'interès al menú desplegable o escriure el seu nom directament al menú.")
              )
            )
          )
        )
      ),
      
      # Card selecció i visualització fitxa
      fluidRow(
        style = "margin-top: 0px; margin-bottom: 20px;",
        column(
          width = 12,
          card(
            class = "overflow-visible",
            card_body(
              style = "overflow: visible;",
              selectInput(
                inputId = "select_fitxes",
                label = h2(
                  icon("book-medical", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                  "Indicador de salut comunitària", class = "title-style", style = "margin-bottom: 5px;"
                ),
                choices = c(
                  " " = "",
                  "Activitat física saludable de la població de 15-69 anys (brut)" = "fitxa_SCES06",
                  "Activitat física saludable de la població de 15-69 anys (estandarditzat)" = "fitxa_SCES07",
                  "Adherència a la dieta mediterrània de la població de 15 anys i més (brut)" = "fitxa_SCES04",
                  "Adherència a la dieta mediterrània de la població de 15 anys i més (estandarditzat)" = "fitxa_SCES05",
                  "Cobertura vacunal de la població infantil" = "fitxa_SCPR01",
                  "Consum de risc d'alcohol de població de 15 anys i més (brut)" = "fitxa_SCES02",
                  "Consum de risc d'alcohol de població de 15 anys i més (estandarditzat)" = "fitxa_SCES03",
                  "Esperança de vida en néixer" = "fitxa_SCMR06",
                  "Gent gran que viu sola" = "fitxa_SCDE03",
                  "Índex de sobreenvelliment" = "fitxa_SCDE02",
                  "Índex socioeconòmic territorial" = "fitxa_SCSO03",
                  "Mitjana de visites de la població assignada i atesa" = "fitxa_SCRE02",
                  "Nombre de defuncions" = "fitxa_SCMR01",
                  "Nombre de defuncions per COVID-19" = "fitxa_SCMR07",
                  "Nombre de defuncions per suïcidi" = "fitxa_SCMR05",
                  "Població amb autopercepció bona de la seva salut (brut)" = "fitxa_SCMO08",
                  "Població amb autopercepció bona de la seva salut (estandarditzat)" = "fitxa_SCMO09",
                  "Població amb autopercepció dolenta de la seva salut (brut)" = "fitxa_SCMO10",
                  "Població amb autopercepció dolenta de la seva salut (estandarditzat)" = "fitxa_SCMO11",
                  "Població amb excés de pes" = "fitxa_SCMO05",
                  "Població amb nacionalitat d'un país en vies de desenvolupament" = "fitxa_SCDE04",
                  "Població amb obesitat" = "fitxa_SCMO07",
                  "Població amb sobrepès" = "fitxa_SCMO06",
                  "Població assignada" = "fitxa_SCDE01",
                  "Població assignada a l'EAP de 75 anys i més que ha estat atesa al programa ATDOM" = "fitxa_SCRE03",
                  "Població assignada i atesa" = "fitxa_SCRE01",
                  "Població atesa a centres ambulatoris de salut mental" = "fitxa_SCRE04",
                  "Població consumidora de fàrmacs" = "fitxa_SCRE05",
                  "Població consumidora de psicofàrmacs" = "fitxa_SCRE06",
                  "Població consumidora de tabac de la població assignada a l'EAP de 15 anys i més" = "fitxa_SCES01",
                  "Població de 0-14 anys atesa a atenció primària" = "fitxa_SCMO01",
                  "Població de 15 anys i més amb dependència (brut)" = "fitxa_SCMO12",
                  "Població de 15 anys i més amb dependència (estandarditzat)" = "fitxa_SCMO13",
                  "Població de 15 anys i més amb diversitat funcional (brut)" = "fitxa_SCMO14",
                  "Població de 15 anys i més amb diversitat funcional (estandarditzat)" = "fitxa_SCMO15",
                  "Població de 15 anys i més atesa a atenció primària" = "fitxa_SCMO02",
                  "Població de 18 anys i més atesa a centres ambulatoris de salut mental" = "fitxa_SCMO03",
                  "Població exempta de copagament de farmàcia" = "fitxa_SCSO01",
                  "Població menor de 18 anys atesa a centres ambulatoris de salut mental" = "fitxa_SCMO04",
                  "Població polimedicada amb 10 ATC o més" = "fitxa_SCRE07",
                  "Taxa bruta de mortalitat" = "fitxa_SCMR02",
                  "Taxa de mortalitat estandarditzada" = "fitxa_SCMR03"
                ),
                selected = "",
                width = "100%"
              ), 
              uiOutput("fitxa_seleccionada")
            )
          )
        )
      ),
      
      tags$div(style = "height: 10px;")
      
    )
    
  )
)

################################################################################

# Servidor de la Shiny app
server <- function(input, output, session) {
  
  # Activar/desactivar mode depuració
  debug_mode <- FALSE
  
  # Funció mostrar missatges modals
  show_message <- function(title, message) {
    showModal(modalDialog(
      title = title,
      message,
      easyClose = TRUE,
      footer = tags$button(
        "D'acord",
        class = "action-button-primary",
        type = "button",
        onclick = "Shiny.setInputValue('close_modal', Math.random());"
      )
    ))
  }
  observeEvent(input$close_modal, {
    removeModal()
  })
  
  # Observar canvis selecció RS
  observeEvent(input$select_rs, {
    if (debug_mode) {
      print(paste("select_rs:", input$select_rs))
    }
    if (is.null(input$select_rs) || length(input$select_rs) == 0) {
      print("Selector RS buit. Resetejar ABS")
      updateSelectInput(session, "select_abs",
                        choices = c("Totes", mixedsort(as.character(unique(df$`Àrea bàsica de salut`)))),
                        selected = NULL)
      return()
    }
    if ("Totes" %in% input$select_rs && length(input$select_rs) > 1) {
      prev_selection <- head(input$select_rs, -1)
      show_message(
        "Selecció no permesa",
        "No es pot seleccionar 'Totes' juntament amb altres regions sanitàries. Es mantindrà la selecció prèvia."
      )
      updateSelectInput(session, "select_rs", selected = prev_selection)
      return()
    }
    if ("Totes" %in% input$select_rs) {
      print("Seleccionat 'Totes'. Mostra totes les ABS")
      updateSelectInput(session, "select_abs",
                        choices = c("Totes", mixedsort(as.character(unique(df$`Àrea bàsica de salut`)))),
                        selected = NULL)
      return()
    }
    selected_abs <- mixedsort(as.character(unique(df$`Àrea bàsica de salut`[df$`Regió sanitària` %in% input$select_rs])))
    print(paste("ABS vàlids:", selected_abs))
    current_abs <- input$select_abs
    valid_abs <- current_abs[current_abs %in% selected_abs]
    updateSelectInput(session, "select_abs",
                      choices = c("Totes", selected_abs),
                      selected = valid_abs)
  }, ignoreInit = TRUE)
  
  # Detecció selector RS buit
  observe({
    if (is.null(input$select_rs) || length(input$select_rs) == 0) {
      print("Selector RS buit")
      updateSelectInput(session, "select_abs",
                        choices = c("Totes", mixedsort(as.character(unique(df$`Àrea bàsica de salut`)))),
                        selected = NULL)
    }
  })
  
  # Observar canvis selecció ABS
  observeEvent(input$select_abs, {
    print(paste("select_abs:", input$select_abs))
    if (is.null(input$select_rs) || length(input$select_rs) == 0) {
      print("No hi ha RS. Resetejar ABS")
      show_message(
        "Selecció no permesa",
        "Cal seleccionar primer una o més regions sanitàries abans de seleccionar àrees bàsiques de salut."
      )
      updateSelectInput(session, "select_abs",
                        choices = c("Totes", mixedsort(as.character(unique(df$`Àrea bàsica de salut`)))),
                        selected = NULL)
      return()
    }
    if (!is.null(input$select_abs) && "Totes" %in% input$select_abs && length(input$select_abs) > 1) {
      prev_selection <- head(input$select_abs, -1)
      show_message(
        "Selecció no permesa",
        "No es pot seleccionar 'Totes' juntament amb altres àrees. Es mantindrà la selecció prèvia."
      )
      updateSelectInput(session, "select_abs", selected = prev_selection)
      return() 
    }
  }, ignoreInit = TRUE)
  
  # Observar canvis selecció àmbits
  observeEvent(input$select_ambits, {
    if (debug_mode) {
      print(paste("select_ambits:", input$select_ambits))
    }
    if (is.null(input$select_ambits) || length(input$select_ambits) == 0) {
      print("Selector àmbits buit. Resetejar indicadors")
      updateSelectInput(session, "select_indicadors",
                        choices = c("Tots", mixedsort(as.character(unique(df$Indicador)))),
                        selected = NULL)
      return()
    }
    if ("Tots" %in% input$select_ambits && length(input$select_ambits) > 1) {
      prev_selection <- head(input$select_ambits, -1)
      show_message(
        "Selecció no permesa",
        "No es pot seleccionar 'Tots' juntament amb altres àmbits. Es mantindrà la selecció prèvia."
      )
      updateSelectInput(session, "select_ambits", selected = prev_selection)
      return()
    }
    if ("Tots" %in% input$select_ambits) {
      print("Seleccionat 'Tots'. Mostra tots els indicadors")
      updateSelectInput(session, "select_indicadors",
                        choices = c("Tots", mixedsort(as.character(unique(df$Indicador)))),
                        selected = NULL)
      return()
    }
    selected_indicadors <- mixedsort(as.character(unique(df$Indicador[df$`Àmbit` %in% input$select_ambits])))
    print(paste("Indicadors vàlids:", selected_indicadors))
    current_indicadors <- input$select_indicadors
    valid_indicadors <- current_indicadors[current_indicadors %in% selected_indicadors]
    updateSelectInput(session, "select_indicadors",
                      choices = c("Tots", selected_indicadors),
                      selected = valid_indicadors)
  }, ignoreInit = TRUE)
  
  # Detecció selector àmbits buit
  observe({
    if (is.null(input$select_ambits) || length(input$select_ambits) == 0) {
      print("Selector àmbits buit")
      updateSelectInput(session, "select_indicadors",
                        choices = c("Tots", mixedsort(as.character(unique(df$Indicador)))),
                        selected = NULL)
    }
  })
  
  # Observar canvis selecció Indicador
  observeEvent(input$select_indicadors, {
    print(paste("select_indicadors:", input$select_indicadors))
    if (is.null(input$select_ambits) || length(input$select_ambits) == 0) {
      print("No hi ha àmbits. Resetejar indicadors")
      show_message(
        "Selecció no permesa",
        "Cal seleccionar primer un o més àmbits abans de seleccionar indicadors de salut comunitària."
      )
      updateSelectInput(session, "select_indicadors",
                        choices = c("Tots", mixedsort(as.character(unique(df$Indicador)))),
                        selected = NULL)
      return()
    }
    if (!is.null(input$select_indicadors) && "Tots" %in% input$select_indicadors && length(input$select_indicadors) > 1) {
      prev_selection <- head(input$select_indicadors, -1)
      show_message(
        "Selecció no permesa",
        "No es pot seleccionar 'Tots' juntament amb altres indicadors. Es mantindrà la selecció prèvia."
      )
      updateSelectInput(session, "select_indicadors", selected = prev_selection)
      return() 
    }
  }, ignoreInit = TRUE)
  
  # Crear variable reactiva per controlar la visibilitat de la taula
  selection_applied <- reactiveVal(FALSE)
  
  # Observar botó aplica la selecció
  observeEvent(input$apply_selection, {
    showModal(modalDialog(
      title = "Confirmar selecció",
      "Segur que vols aplicar la selecció actual?",
      easyClose = TRUE,
      footer = tagList(
        tags$button(
          "Confirmar",
          class = "action-button-primary",
          type = "button",
          onclick = "Shiny.setInputValue('confirm_apply', Math.random());"
        ),
        tags$button(
          "Cancel·lar",
          class = "action-button-primary",
          type = "button",
          onclick = "Shiny.setInputValue('cancel_apply', Math.random());"
        )
      )
    ))
  })
  
  # Observar cancel·lació selecció
  observeEvent(input$cancel_apply, {
    removeModal()
  })
  
  # Observar confirmació selecció
  observeEvent(input$confirm_apply, {
    selection_applied(TRUE)
    removeModal()
  })
  
  # Observar botó netejar selecció
  observeEvent(input$clear_selection, {
    if (is.null(input$select_rs) && is.null(input$select_abs) && 
        is.null(input$select_ambits) && is.null(input$select_indicadors)) {
       show_message(
        "Cap selecció activa",
        "No hi ha cap selecció per netejar."
      )
    } else {
      showModal(modalDialog(
        title = "Confirmar neteja",
        "Segur que vols netejar la selecció actual?",
        easyClose = TRUE,
        footer = tagList(
          tags$button(
            "Confirmar",
            class = "action-button-primary",
            type = "button",
            onclick = "Shiny.setInputValue('confirm_clear', Math.random());"
          ),
          tags$button(
            "Cancel·lar",
            class = "action-button-primary",
            type = "button",
            onclick = "Shiny.setInputValue('cancel_clear', Math.random());"
          )
        )
      ))
    }
  })
  
  # Observar cancel·lació neteja
  observeEvent(input$cancel_clear, {
    removeModal()
  })
  
  # Observar confirmació neteja
  observeEvent(input$confirm_clear, {
    updateSelectInput(session, "select_rs", 
                      choices = c("Totes", mixedsort(as.character(unique(df$`Regió sanitària`)))),
                      selected = NULL)
    updateSelectInput(session, "select_abs",
                      choices = c("Totes", mixedsort(as.character(unique(df$`Àrea bàsica de salut`)))),
                      selected = NULL)
    updateSelectInput(session, "select_ambits",
                      choices = c("Tots", mixedsort(as.character(unique(df$`Àmbit`)))),
                      selected = NULL)
    updateSelectInput(session, "select_indicadors",
                      choices = c("Tots", mixedsort(as.character(unique(df$Indicador)))),
                      selected = NULL)
    selection_applied(FALSE)
    removeModal()
  })
  
  # Gestionar la visualització condicional de la taula de dades
  output$taula_container <- renderUI({
    if (selection_applied()) {
      dataTableOutput("taula_dades")
    } else {
      div(
        style = "text-align: center; 
               padding: 30px; 
               color: #1565C0;
               background: linear-gradient(135deg, #E3F2FD, #90CAF9);
               border-radius: 10px;
               box-shadow: 0 2px 4px rgba(0,0,0,0.1);
               margin-top: 0px;",
        div(
          style = "font-size: 16px; line-height: 1.5;",
          HTML("
          <i class='fas fa-info-circle' style='font-size: 24px; margin-bottom: 15px; color: #1565C0;'></i><br>
          <span style='font-size: 16px; font-weight: 600;'>Seguint els passos, selecciona les regions, àrees, àmbits i indicadors d'interès, fes clic al botó <code style='color: #1565C0;'>Aplica la selecció</code> i confirma la selecció.</span><br>
          <span style='font-size: 14px; color: #1976D2;'>Si no selecciones cap elements i confirmes, es mostrarà una taula amb totes les dades disponibles.</span><br>
          <span style='font-size: 14px; color: #1976D2;'>Un cop es mostri la taula, podràs modificar les seleccions en temps real sense necessitat de confirmar.</span>
        ")
        )
      )
    }
  })
  
  # Renderitzar la taula de dades amb les seleccions aplicades
  output$taula_dades <- renderDataTable({
    
    req(selection_applied())
    dades_seleccionades <- df
    if (!is.null(input$select_rs) && !("Totes" %in% input$select_rs)) {
      dades_seleccionades <- subset(dades_seleccionades, `Regió sanitària` %in% input$select_rs)
    }
    if (!is.null(input$select_abs) && !("Totes" %in% input$select_abs)) {
      dades_seleccionades <- subset(dades_seleccionades, `Àrea bàsica de salut` %in% input$select_abs)
    }
    if (!is.null(input$select_ambits) && !("Tots" %in% input$select_ambits)) {
      dades_seleccionades <- subset(dades_seleccionades, `Àmbit` %in% input$select_ambits)
    }
    if (!is.null(input$select_indicadors) && !("Tots" %in% input$select_indicadors)) {
      dades_seleccionades <- subset(dades_seleccionades, Indicador %in% input$select_indicadors)
    }
    
    # Definir les opcions de la taula
    datatable(
      dades_seleccionades,
      style = "default",
      extensions = 'Buttons',
      plugins = 'natural', # https://forum.posit.co/t/how-to-sort-alphanumeric-column-by-natural-numbers-in-a-datatable/2262
      rownames = FALSE,
      options = list(
        autoWidth = FALSE,
        pageLength = nrow(dades_seleccionades),
        dom = 'Bfrti',
        initComplete = JS("function(settings, json) {
          // Estil 1a fila taula
          $(this.api().table().header()).css({
            'background-color': '#5EAEFF',
            'color': '#FFFFFF'
          });
      
          // Espai vertical elements
          $('.dt-buttons').css('margin-bottom', '10px');
          $('.dataTables_filter').css('margin-bottom', '10px');
          $('.dataTables_info').css({'margin-top': '-10px', 'margin-bottom': '50px'}); 
      
          // Estil botons exportació
          $('.dt-button').addClass('action-button-primary');
          $('<style>')
          .prop('type', 'text/css')
          .html(`
            .dt-button.action-button-primary {
              margin-top: 0px;
              color: white !important;
              background-color: #5EAEFF !important;
              border: none !important;
              border-radius: 20px !important;
              padding: 8px 16px !important;
              transition: background-color 0.3s !important;
            }
            .dt-button.action-button-primary:hover {
              background-color: #1565C0 !important;
              color: white !important;
            }
          `)
          .appendTo('head');
          
          // Estil barra cerca
          $('<style>')
          .prop('type', 'text/css')
          .html(`
            .dataTables_filter input {
              border: none;
              outline: none;
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
            extend = "csv", 
            text = '<i class="fa fa-file-csv" style="margin-right: 5px;"></i> CSV',
            titleAttr = "Exporta la taula de dades en format CSV",
            filename = "dades_indicadors_salut_comunitaria",
            title = NULL,
            exportOptions = list(
              charset = "UTF-8",
              orthogonal = 'export'
            ),
            customize = JS("function(csv) {
              var header = 'regio_sanitaria;area_basica_salut;ambit;indicador;mesura;periode;abs_homes;abs_dones;abs_total;catalunya_homes;catalunya_dones;catalunya_total\\n';
              var rows = csv.split('\\n');
              var processedRows = rows.slice(1).map(function(row) {
                row = row.replace(/\",\"/g, ';');
                var columns = row.split(';').map(val => val.replace(/\"/g, ''));
                if (columns[4] !== 'Persones') {
                  for(var i = 6; i < columns.length; i++) {
                    if(columns[i].includes('.')) {
                      columns[i] = columns[i].replace('.', ',');
                    }
                  }
                }
                return columns.join(';');
              });
              return '\ufeff' + header + processedRows.join('\\n');
            }")
          ),
          list(
            extend = "excel", 
            text = '<i class="fa fa-file-excel" style="margin-right: 5px;"></i> XLSX',
            titleAttr = "Exporta la taula de dades en format XLSX (Excel)",
            filename = "dades_indicadors_salut_comunitaria",
            title = NULL,
            exportOptions = list(
              orthogonal = 'export'
            ),
            customize = JS("function(xlsx) {
              var sheet = xlsx.xl.worksheets['sheet1.xml'];
              var headers = ['regio_sanitaria', 'area_basica_salut', 'ambit', 'indicador', 'mesura', 'periode', 'abs_homes', 'abs_dones', 'abs_total', 'catalunya_homes', 'catalunya_dones', 'catalunya_total'];
              $('row:first c', sheet).each(function(i) {
                $(this).find('t').text(headers[i]);
              });
            }")
          ),
          list(
            extend = "pdf", 
            text = '<i class="fa fa-file-pdf" style="margin-right: 5px;"></i> PDF',
            titleAttr = "Exporta la taula de dades en format PDF",
            filename = "dades_indicadors_salut_comunitaria",
            title = NULL,
            orientation = "landscape",
            pageSize = "A4",
            customize = JS("function(doc) {
            
              doc.defaultStyle.fontSize = 8;
              doc.styles.tableHeader.fontSize = 8;
              doc.pageMargins = [20, 20, 20, 20];
              
              doc.content[0].table.body.forEach(function(row, index) {
                for(var i = 0; i <= 4; i++) {
                  if(row[i]) row[i].alignment = 'left';
                }
                for(var i = 5; i < row.length; i++) {
                  if(row[i]) row[i].alignment = 'center';
                }
      
                if(index === 0) {
                  row.forEach(function(cell) {
                    cell.fillColor = '#5EAEFF';
                    cell.color = '#FFFFFF';
                  });
                }
              });
            }")
          )
        ),
        language = list(
          search = "<i class='glyphicon glyphicon-search'></i>",
          emptyTable = "No hi ha registres disponibles",
          zeroRecords = "No s'han trobat registres coincidents",
          info = "Registres disponibles: _TOTAL_",
          infoEmpty = "",
          infoFiltered = "",
          thousands = "."
        ),
        columnDefs = list(
          list(visible = FALSE, targets = 0),
          list(className = 'dt-left', targets = 1:4), 
          list(className = 'dt-center', targets = 5:11),
          list(type = 'natural', targets = c(1:11)), # https://forum.posit.co/t/how-to-sort-alphanumeric-column-by-natural-numbers-in-a-datatable/2262
          list(
            targets = c(1:4),
            # Eliminem els accents de les columnes 1-4 per ordenar-les correctament i restablim els accents després de la ordenació
            render = JS("
              function(data, type, row) {
                if (type === 'sort') {
                  return data.normalize('NFD').replace(/[\\u0300-\\u036f]/g, '').toLowerCase();
              }
              return data;
            }
          ")
          ),
          list(
            targets = 6:11,
            # Manipulem les dades de les columnes 6-11 per assegurar una ordenació, visualització i exportació correcta (NO FUNCIONA ORDENACIÓ <10)
            render = JS("function(data, type, row) {
            
            if (type === 'sort') {
              if (typeof data === 'string' && data.trim() === '<10') { // NO FUNCIONA
                return -999999998;
              }
              if (typeof data === 'string' && data.includes('(')) {
                return Number(data.split('(')[0].trim().replace(',', '.'));
              }
              if (data === null || data === 'NA' || data === '—') {
                return -999999999;
              }
              return typeof data === 'number' ? data : Number(data.replace(',', '.'));
            }
            
              if (typeof data === 'string' && isNaN(Number(data))) {
                return data;
              }
            
              if (data === null || data === 'NA') {
                if (type === 'export') {
                  return 'NA';
                }
                if (type === 'display' || type === 'pdf') {
                  return '—'; 
                }
                return data;
                }
              if (type === 'export') {
                return data;
              }
              
              if (type === 'display') {
                if (row[4] !== 'Persones') {
                  return new Intl.NumberFormat('es-ES', {
                    minimumFractionDigits: 1,
                    maximumFractionDigits: 2,
                    useGrouping: true
                  }).format(data);
              } else {
                return new Intl.NumberFormat('es-ES', {
                  minimumFractionDigits: 0,
                  maximumFractionDigits: 0,
                  useGrouping: true
                }).format(data);
              }
            }
            return data;
            }")
          )
        )
      )
    )
  },
  server = FALSE # https://forum.posit.co/t/how-to-sort-alphanumeric-column-by-natural-numbers-in-a-datatable/2262
 )
  
  # Mostrar GWalkR
  output$analisi_exploratoria_dades_eda = renderGwalkr({
    gwalkr(df_gwalkr)
  })
  
  # Mostrar fitxa seleccionada
  output$fitxa_seleccionada <- renderUI({
    
    if (input$select_fitxes == "") {
      return(NULL)
    }
    
    switch(input$select_fitxes,
           
           "fitxa_SCDE01" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Població assignada a un equip d'atenció primària (EAP) que ha estat assignada per aquest equip en l'any d'estudi.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("Població assignada a l'EAP.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (0-14 anys, 15-54 anys, 55-64 anys i 65 anys i més). El nivell socioeconòmic individual es calcula tenint en compte el nivell de renda individual, 
               la situació laboral actual (relació amb la Seguretat Social) i el copagament farmacèutic.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre Central d'Assegurats (RCA), Servei Català de la Salut (CatSalut).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCDE02" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Indicador demogràfic que mesura el grau de sobreenvelliment d'una població d'edat avançada. Aquest índex ajuda a identificar 
               les necessitats específiques dels grups de població molt longeva, que sovint requereixen més atenció sanitària i serveis socials.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població assegurada de 85 anys i més "
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assegurada de 65 anys i més"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre Central d'Assegurats (RCA), Servei Català de la Salut (CatSalut).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCDE03" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Indicador demogràfic que proporciona informació sobre les condicions de vida de la població gran i pot ser interpretat com una mesura d'autonomia
               i vulnerabilitat, ja que pot reflectir una situació de risc, viure sol pot augmentar la probabilitat d'aïllament social, dificultats per accedir a 
               recursos o falta d'assistència en cas de necessitats mèdiques o urgents.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població de 65 anys i més que viu sola"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població de totes les edats"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (65-74 anys, 75-84 anys i 85 anys i més).",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Institut d'Estadística de Catalunya (Idescat).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCDE04" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Indicador demogràfic que permet identificar necessitats específiques i planificar recursos i serveis sanitaris adequats per a aquesta població.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població del grup d'edat determinat amb nacionalitat d'un país en via de desenvolupament"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població del mateix grup d'edat"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (0-14 anys, 15-44 anys, 45-64 anys i 65 anys i més). Es consideren països en via de desenvolupament: 
               Afganistan, Algèria, Angola, Anguilla, Antigua i Barbuda, Antilles Neerlandeses, Aràbia Saudita, Argentina, Armènia, Aruba, Azerbaidjan, 
               Bahames, Bahrain, Bangladesh, Barbados, Belize, Benín, Bhutan, Bolívia, Botswana, Brasil, Brunei, Burkina Faso, Burundi, Cambodja, Camerun, 
               Cap Verd, Colòmbia, Comores, Congo, Corea del Nord, Corea del Sud, Costa d'Ivori, Costa Rica, Cuba, Djibouti, Dominica, Egipte, El Salvador, 
               Emirats Àrabs Units, Equador, Eritrea, Etiòpia, Fiji, Filipines, Gabon, Gàmbia, Geòrgia, Ghana, Grenada, Guadalupe, Guaiana Francesa, Guam, 
               Guatemala, Guinea, Guinea Equatorial, Guinea Bissau, Guyana, Haití, Hondures, Hong Kong, Xina, Iemen, Illes Caiman, Illes Cook, Illes Falkland (Malvines), 
               Illes Mariannes del Nord, Illes Marshall, Illes Salomó, Illes Turks i Caicos, Illes Verges Britàniques, Illes Verges dels Estats Units, Índia, 
               Indonèsia, Iran, Iraq, Israel, Jamaica, Jordània, Kazakhstan, Kenya, Kirguizistan, Kiribati, Kuwait, Laos, Lesotho, Líban, Libèria, Líbia, 
               Macau, Xina, Madagascar, Malàisia, Malawi, Maldives, Mali, Marroc, Martinica, Maurici, Mauritània, Mayotte, Mèxic, Micronèsia, Moçambic, 
               Mongòlia, Montserrat, Myanmar, Namíbia, Nauru, Nepal, Nicaragua, Níger, Nigèria, Niue, Nova Caledònia, Oman, Pakistan, Palau, Panamà, 
               Papua Nova Guinea, Paraguai, Perú, Pitcairn, Polinèsia Francesa, Puerto Rico, Qatar, República Centreafricana, República Democràtica del Congo, 
               República Dominicana, Reunió, Ruanda, Sàhara Occidental, Saint Helena, Ascensió i Tristan da Cunha, Saint Christopher i Nevis, Saint Lucia, 
               Saint Vincent i les Grenadines, Saint Barthélemy, Saint-Martin, Samoa, Samoa Nord-americana, São Tomé i Príncipe, Senegal, Seychelles, Sierra Leone, 
               Singapur, Síria, Somàlia, Sri Lanka, Sud-àfrica, Sudan del Sud, Sudan, Surinam, Swazilàndia, Tadjikistan, Tailàndia, Taiwan, Tanzània, 
               Territoris Palestins o Palestina, Timor Oriental, Togo, Tokelau, Tonga, Trinitat i Tobago, Tunísia, Turkmenistan, Turquia, Tuvalu, Txad, Uganda, 
               Uruguai, Uzbekistan, Vanuatu, Veneçuela, Vietnam, Wallis i Futuna, Xile, Xina, Zàmbia i Zimbàbue.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Institut d'Estadística de Catalunya (Idescat).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCSO01" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Aquest indicador ens informa de les persones que degut a la seva situació econòmica vulnerable estan exemptes de copagament farmacèutic. 
               Són persones que principalment es troben en alguna situació següent: perceptores de rendes de d'integració social, perceptores de pensió 
               no contributiva, en atur i que han perdut el dret a percebre el subsidi d'atur o beneficiaries de l'ingrés mínim vital.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població exempta de copagament de farmàcia"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assegurada"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre Central d'Assegurats (RCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCSO03" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("L'índex socioeconòmic territorial (IST) és un índex sintètic que es defineix com una ponderació de sis indicadors de situació laboral, nivell d'estudis, immigració i renda:",
               style = "margin-bottom: 10px; text-align: justify;"),
             
             tags$ul(
               tags$li("Població ocupada."),
               tags$li("Treballadors de baixa qualificació."),
               tags$li("Població amb estudis baixos."),
               tags$li("Població jove sense estudis postobligatoris."),
               tags$li("Estrangers de països de renda baixa o mitjana."),
               tags$li("Renda mitjana per persona."),
               style = "margin-bottom: 10px;"
             ),
             
             p("La metodologia utilitzada per al càlcul de l'IST ha estat l'anàlisi de components principals a partir de les seccions censals.",
               style = "margin-bottom: 10px; text-align: justify;"),
             
             p("L'IST és un índex sintètic per petites àrees que resumeix en un únic valor diverses característiques socioeconòmiques de la població resident en un territori
               i quantifica les diferències dins de Catalunya. El valor mitjà del conjunt de Catalunya és 100; per tant, quan un valor de l'IST és inferior a 100 equival a un nivell 
               socioeconòmic inferior a la mitjana catalana, i com més baix sigui el valor de l'IST més baix és el nivell socioeconòmic del territori que representa. 
               Per a l'anàlisi de resultats s'han definit 6 categories de nivell socioeconòmic segons el valor de l'IST: molt baix (menor de 75), baix (de 75 a 90), 
               mitjà baix (de 90 a 100), mitjà alt (de 100 a 110), alt (de 110 a 125) i molt alt (major de 125).",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("—",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2020",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("—",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO01" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Població de 0 a 14 anys assignada i atesa per alguna de les següents patologies: altres hèrnies abdominals; trastorns de refracció; 
               deformitats adquirides de la columna; deformitats adquirides de les extremitats; migranya; síndrome del túnel carpià; trastorn d'ansietat i angoixa; 
               ceguesa; fòbia o trastorn compulsiu; hipertròfia d'amígdales/adenoides; asma; rinitis al·lèrgica; síndrome d'apnea del son; obesitat; hipotiroïdisme/mixedema; 
               criptoquídia; trastorns hipercinètics; o osteocondrosi.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població de 0 a 14 anys atesa a atenció primària segons diagnòstics seleccionats"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població de 0 a 14 anys assignada a l'equip d'atenció primària"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO02" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Població de 15 anys i més assignada i atesa per alguna de les següents patologies: alteracions del metabolisme lipídic; 
               diabetis no insulinodependent; depressió; altres malalties del cor; altres artrosis; hipertròfia prostàtica benigna; hipotiroïdisme/mixedema; 
               hipertensió arterial no complicada; trastorn ansietat/angoixa/estat ansiós; osteoporosis; varius a les cames; o obesitat.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població de 15 anys i més atesa a atenció primària segons diagnòstics seleccionats"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població de 15 anys i més assignada a l'equip d'atenció primària"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO03" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Població de 18 anys i més assignada i atesa per alguna de les següents patologies: amb qualsevol diagnòstic de salut mental;
               trastorn per esquizofrènia; trastorn depressiu; trastorn bipolar; altres trastorns de l'estat d'ànim; ansietat i trastorns de la por;
               trastorn obsessivocompulsiu; trastorns per traumes i estrès; trastorns de conducta; trastorns de la personalitat;
               trastorns de la conducta alimentària; trastorns somàtics; idees suïcides; trastorns de comportament; o trastorns del neurodesenvolupament.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població de 18 anys i més atesa a CSM segons diagnòstics seleccionats"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població de 18 anys i més atesa a CSM"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO04" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Població menor de 18 anys assignada i atesa per alguna de les següents patologies: trastorns de la conducta alimentària; 
               trastorns de conducta; trastorn de l'espectre autista; dèficit d'atenció i/o hiperactivitat; o trastorn adaptatiu.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població de menys de 18 anys atesa a CSM segons diagnòstics seleccionats"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població de menys de 18 anys atesa a CSM"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO05" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Població assignada amb sobrepès o obesitat.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb sobrepès o obesitat"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada a l'equip d'atenció primària"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (6-17 anys i 18-74 anys).",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO06" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Població assignada amb sobrepès.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb sobrepès"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada a l'equip d'atenció primària"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (6-17 anys i 18-74 anys). L'indicador es calcula de manera diferent depenent del grup d'edat. 
               Pels infants de 6 a 17 anys es calcula com la població assignada i atesa amb un pes entre el percentil 90 i 95 o un codi diagnòstic d'augment 
               anormal de pes. Pel grup d'edat de 18 a 74 anys es calcula com la població assignada i atesa amb un Índex de massa corporal (IMC) > 25 i ≤ 30 
               o un codi diagnòstic d'augment anormal de pes.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO07" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Població assignada amb obesitat.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb obesitat"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada a l'equip d'atenció primària"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (6-17 anys i 18-74 anys). L'indicador es calcula de manera diferent depenent del grup d'edat. 
               Pels infants de 6 a 17 anys es calcula com la població assignada i atesa amb un pes per sobre el percentil 95 o un codi diagnòstic d'obesitat. 
               Pel grup d'edat de 18 a 74 anys es calcula com la població assignada i atesa amb un Índex de massa corporal (IMC) > 30 o un codi diagnòstic d'obesitat.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO08" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("La dada s'obté de preguntar: «Com diria vostè que és la seva salut en general?». Es considera percepció positiva de la salut quan s'ha contestat 
               «excel·lent», «molt bona» o «bona», i percepció negativa quan es respon «regular» o «dolenta».",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb autopercepció bona de la salut"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població total"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO09" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("La dada s'obté de preguntar: «Com diria vostè que és la seva salut en general?». Es considera percepció positiva de la salut quan s'ha contestat 
               «excel·lent», «molt bona» o «bona», i percepció negativa quan es respon «regular» o «dolenta».",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb autopercepció bona de la salut"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població total"
                 )
               ),
               "× 100 + Interval de confiança al 95%"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO10" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("La dada s'obté de preguntar: «Com diria vostè que és la seva salut en general?». Es considera percepció positiva de la salut quan s'ha contestat 
               «excel·lent», «molt bona» o «bona», i percepció negativa quan es respon «regular» o «dolenta».",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb autopercepció dolenta de la salut"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població total"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO11" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("La dada s'obté de preguntar: «Com diria vostè que és la seva salut en general?». Es considera percepció positiva de la salut quan s'ha contestat 
               «excel·lent», «molt bona» o «bona», i percepció negativa quan es respon «regular» o «dolenta».",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb autopercepció dolenta de la salut"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població total"
                 )
               ),
               "× 100 + Interval de confiança al 95%"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO12" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("S'obté mitjançant una pregunta sobre la necessitat d'ajuda o de companyia per realitzar activitats habituals de la vida quotidiana a causa d'un problema de salut.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb dependència"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població total"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO13" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("S'obté mitjançant una pregunta sobre la necessitat d'ajuda o de companyia per realitzar activitats habituals de la vida quotidiana a causa d'un problema de salut.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb dependència"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població total"
                 )
               ),
               "× 100 + Interval de confiança al 95%"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO14" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("S'estima a partir d'una llista amb onze tipus diferents de limitacions greus que afecten de manera permanent la capacitat per desenvolupar activitats quotidianes.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb diversitat funcional"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població total"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMO15" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("S'estima a partir d'una llista amb onze tipus diferents de limitacions greus que afecten de manera permanent la capacitat per desenvolupar activitats quotidianes.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població amb diversitat funcional"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població total"
                 )
               ),
               "× 100 + Interval de confiança al 95%"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMR01" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("L'estadística s'elabora amb les defuncions de residents i morts a Catalunya. La població assegurada per ABS que s'ha fet servir en els càlculs dels 
               indicadors prové del Registre Central d'Assegurats.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("Nombre de defuncions en el període d'estudi.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2015-2019, 2020, 2021",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre de Mortalitat de Catalunya (RMC).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMR02" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("L'estadística s'elabora amb les defuncions de residents i morts a Catalunya. La població assegurada per ABS que s'ha fet servir en els càlculs dels 
               indicadors prové del Registre Central d'Assegurats.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Nombre de defuncions en el període n"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assegurada període n"
                 )
               ),
               "× 1.000"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p(paste("Disponible per sexe i ABS. Es calcula per les següents causes de defunció: certes malalties infeccioses i parasitàries; 
                     tumors; malalties endocrines, nutricionals i metabòliques; trastorns mentals i del comportament; malalties del sistema nerviós; 
                     malalties de l'aparell circulatori; malalties de l'aparell respiratori; malalties de l'aparell digestiu; malalties del sistema osteomuscular 
                     i del teixit conjuntiu; malalties de l'aparell genitourinari; símptomes i signes mal definits; i causes externes de morbiditat i mortalitat."),
               tags$a(href = "https://scientiasalut.gencat.cat/bitstream/handle/11351/9769/metodologia_analisi_mortalitat_catalunya_document_metodologic_registre_mortalitat_catalunya_2023.pdf?sequence=1&isAllowed=y",
                      style = "margin-left: 5px;",
                      icon("arrow-up-right-from-square", style = "font-size: 16px; color: #5E5E5E;"),
                      title = "Més informació sobre la metodologia de l'anàlisi de la mortalitat a Catalunya",
                      target = "_blank"),
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2015-2019, 2020, 2021",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre de Mortalitat de Catalunya (RMC).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMR03" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("L'estadística s'elabora amb les defuncions de residents i morts a Catalunya. La població assegurada per ABS que s'ha fet servir en els càlculs dels 
                indicadors prové del Registre Central d'Assegurats.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Sumatori de la taxa específica de mortalitat de cada tram d'edat del període n × Població tipus de cada tram d'edat"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Sumatori de la població tipus en tots els trams d'edat"
                 )
               )
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p(paste("Disponible per sexe i ABS."),
               tags$a(href = "https://scientiasalut.gencat.cat/bitstream/handle/11351/9769/metodologia_analisi_mortalitat_catalunya_document_metodologic_registre_mortalitat_catalunya_2023.pdf?sequence=1&isAllowed=y",
                      style = "margin-left: 5px;",
                      icon("arrow-up-right-from-square", style = "font-size: 16px; color: #5E5E5E;"),
                      title = "Més informació sobre la metodologia de l'anàlisi de la mortalitat a Catalunya",
                      target = "_blank"),
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2015-2019, 2020, 2021",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre de Mortalitat de Catalunya (RMC).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMR05" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("L'estadística s'elabora amb les defuncions de residents i morts a Catalunya. La població assegurada per ABS que s'ha fet servir en els càlculs dels 
               indicadors prové del Registre Central d'Assegurats.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("Nombre de defuncions per suïcidi en el període d'estudi.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p(paste("Disponible per sexe i ABS. Per tal de mantenir el secret estadístic, el nombre de defuncions per suïcidi a les ABS amb menys de 10 casos apareixerà com <10, excepte en el període 2015-2019."),
               tags$a(href = "https://scientiasalut.gencat.cat/bitstream/handle/11351/9769/metodologia_analisi_mortalitat_catalunya_document_metodologic_registre_mortalitat_catalunya_2023.pdf?sequence=1&isAllowed=y",
                      style = "margin-left: 5px;",
                      icon("arrow-up-right-from-square", style = "font-size: 16px; color: #5E5E5E;"),
                      title = "Més informació sobre la metodologia de l'anàlisi de la mortalitat a Catalunya",
                      target = "_blank"),
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2015-2019, 2020, 2021",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre de Mortalitat de Catalunya (RMC).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMR06" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("L'estadística s'elabora amb les defuncions de residents i morts a Catalunya. La població assegurada per ABS que s'ha fet servir en els càlculs dels 
               indicadors prové del Registre Central d'Assegurats.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p(HTML("La metodologia emprada per al càlcul de la taula de vida es pot consultar al web del Departament en el document <i>Metodologia de l'anàlisi de la mortalitat a Catalunya</i>."),
               tags$a(href = "https://scientiasalut.gencat.cat/bitstream/handle/11351/9769/metodologia_analisi_mortalitat_catalunya_document_metodologic_registre_mortalitat_catalunya_2023.pdf?sequence=1&isAllowed=y",
                      style = "margin-left: 5px;",
                      icon("arrow-up-right-from-square", style = "font-size: 16px; color: #5E5E5E;"),
                      title = "Enllaç extern",
                      target = "_blank"),
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2015-2019, 2020, 2021",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre de Mortalitat de Catalunya (RMC).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCMR07" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("L'estadística s'elabora amb les defuncions de residents i morts a Catalunya. La població assegurada per ABS que s'ha fet servir en els càlculs dels 
                indicadors prové del Registre Central d'Assegurats.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("Nombre de defuncions per COVID-19 en el període d'estudi.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Per tal de mantenir el secret estadístic, el nombre de defuncions per COVID-19 a les ABS amb menys de 10 casos apareixerà com <10.",
               tags$a(href = "https://scientiasalut.gencat.cat/bitstream/handle/11351/9769/metodologia_analisi_mortalitat_catalunya_document_metodologic_registre_mortalitat_catalunya_2023.pdf?sequence=1&isAllowed=y",
                      style = "margin-left: 5px;",
                      icon("arrow-up-right-from-square", style = "font-size: 16px; color: #5E5E5E;"),
                      title = "Més informació sobre la metodologia de l'anàlisi de la mortalitat a Catalunya",
                      target = "_blank"),
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2020, 2021",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Registre de Mortalitat de Catalunya (RMC).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCES01" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Permet mesurar la prevalença del consum de tabac de la població assignada a l'equip d'atenció primària (EAP), una dada essencial per comprendre l'abast d'aquest hàbit en una comunitat específica.
                Serveix com a indicador del risc associat a malalties relacionades amb el consum de tabac, com malalties respiratòries cròniques, càncer de pulmó, malalties cardiovasculars
               i altres patologies.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Consum de tabac de la població assignada a l'EAP de 15 anys i més"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada a l'EAP de 15 anys i més"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCES02" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Aquest indicador és clau en salut pública per avaluar l'impacte de l'alcohol en la salut de la comunitat. Aquest indicador permet identificar
               el percentatge de persones que tenen un consum d'alcohol considerat de risc, és a dir, aquells patrons de consum que poden provocar problemes físics, psíquics o social.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("—",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF. Es calcula usant la informació sobre la freqüència del consum d'alcohol, 
               el tipus de beguda consumida, la quantitat i la distribució del consum al llarg de la setmana. 
               Es categoritza la població per unitat de consum diari d'alcohol, estimada a partir de l'estandardització del tipus de beguda alcohòlica consumida (unitat de beguda estàndard, UBE). 
               Es classifiquen com a consum de risc: en els homes, aquells que prenen 28 o més unitats/setmana; en les dones, les que prenen 16 unitats/setmana. 
               També es considera consum de risc quan les persones consumeixen 5 o més consumicions seguides almenys un cop al mes.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCES03" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Aquest indicador és clau en salut pública per avaluar l'impacte de l'alcohol en la salut de la comunitat. Aquest indicador permet identificar 
               el percentatge de persones que tenen un consum d'alcohol considerat de risc, és a dir, aquells patrons de consum que poden provocar problemes físics, psíquics o social.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("—",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF. Es calcula usant la informació sobre la freqüència del consum d'alcohol, 
               el tipus de beguda consumida, la quantitat i la distribució del consum al llarg de la setmana. 
               Es categoritza la població per unitat de consum diari d'alcohol, estimada a partir de l'estandardització del tipus de beguda alcohòlica consumida (unitat de beguda estàndard, UBE). 
               Es classifiquen com a consum de risc: en els homes, aquells que prenen 28 o més unitats/setmana; en les dones, les que prenen 16 unitats/setmana. També es considera consum de risc quan les persones
               consumeixen 5 o més consumicions seguides almenys un cop al mes.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCES04" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Aquest indicador és clau per avaluar la qualitat de l'alimentació d'una població en relació amb el patró dietètic mediterrani, reconegut com un model alimentari saludable.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("—",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF. Es recull amb l'instrument MEDAS (Mediterranean Diet Adherence Screener), 
               que consta de 14 preguntes sobre els diferents elements de la dieta mediterrània. 
               S'hi estableixen tres categories: compliment baix (≤ 5 punts), compliment mitjà (entre 6 i 9 punts) i compliment alt (≥ 10 punts). Es considera com a seguiment adequat de les recomanacions
               d'alimentació mediterrània els nivells de compliment mitjà i alt.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCES05" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Aquest indicador és clau per avaluar la qualitat de l'alimentació d'una població en relació amb el patró dietètic mediterrani, reconegut com un model alimentari saludable.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("—",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF. Es recull amb l'instrument MEDAS (Mediterranean Diet Adherence Screener), que consta de 14 preguntes sobre els diferents elements de la dieta mediterrània. 
               S'hi estableixen tres categories: compliment baix (≤ 5 punts), compliment mitjà (entre 6 i 9 punts) i compliment alt (≥ 10 punts). Es considera com a seguiment adequat de les recomanacions 
               d'alimentació mediterrània els nivells de compliment mitjà i alt.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCES06" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Aquest indicador mesura el grau en què les persones d'aquest rang d'edat compleixen les recomanacions d'activitat física per mantenir un estil de vida saludable, segons les directrius de l'Organització Mundial de la Salut (OMS). 
               Aquestes recomanacions inclouen almenys 150-300 minuts setmanals d'activitat física aeròbica moderada o 75-150 minuts d'activitat vigorosa, combinades amb exercicis de força.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("—",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF. Es mesura a partir de l'instrument IPAQ, que classifica la població en tres categories: baixa, moderada i alta. Es considera activitat física saludable la suma de l'activitat moderada i l'alta.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCES07" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Aquest indicador mesura el grau en què les persones d'aquest rang d'edat compleixen les recomanacions d'activitat física per mantenir un estil de vida saludable, segons les directrius de l'Organització Mundial de la Salut (OMS). 
               Aquestes recomanacions inclouen almenys 150-300 minuts setmanals d'activitat física aeròbica moderada o 75-150 minuts d'activitat vigorosa, combinades amb exercicis de força.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("—",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS. Les dades es calculen per Sector Sanitari Funcional (SSF) i s'imputa a cada ABS el valor corresponen del seu SSF. Es mesura a partir de l'instrument IPAQ, que classifica la població en tres categories: baixa, moderada i alta. Es considera activitat física saludable la suma de l'activitat moderada i l'alta.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2019-2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Enquesta de Salut de Catalunya (ESCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCPR01" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Percentatge de població entre 0 i 14 anys correctament vacunada, segons el calendari sistemàtic vacunal vigent, amb les vacunes següents: 
               diftèria; tètanus; pertussis; poliomielitis; Hib (Haemophilus); TV (triple vírica: xarampió, rubèola i parotiditis); MCC (antimeningocòccica C); 
               VHB (hepatitis B); meningococ B; antipneumocòccica conjugada; papil·loma humà; hepatitis A; varicel·la; i antimeningocòccica ACWY.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població atesa assignada amb edat compresa entre 0-14 anys que té administrades el nombre mínim de dosis de cadascuna de les vacunes seleccionades segons l'edat actual, o bé que no s'hagi superat el temps màxim establert des de la darrera dosi administrada"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població atesa assignada amb edat compresa entre 0-14 anys"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (0-1 anys, 2-4 anys, 5-9 anys i 10-14 anys).",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCRE01" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Nombre de persones assignades i ateses per un equip d'atenció primària (EAP). 
               S'entén com a persona atesa aquella que s'ha visitat almenys un cop durant l'any seleccionat en qualsevol equip d'atenció primària.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             p("Persones assignades i ateses (amb almenys una visita durant el període) a l'EAP.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (0-14 anys, 15-54 anys, 55-64 anys i 65 anys i més).",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Conjunt mínim bàsic de dades (CMBD), Registre Central d'Assegurats (RCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCRE02" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Mitjana de visites de la població assignada a l'equip d'atenció primària (EAP), ateses per medicina de família, infermeria, pediatria, odontologia i treball social.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Nombre de visites de la població assignada i atesa a l'EAP"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada i atesa a l'EAP"
                 )
               )
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i tipologia de visita.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Conjunt mínim bàsic de dades (CMBD).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCRE03" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Percentatge de població assignada a l'equip d'atenció primària (EAP) de 75 anys i més, inclosa al programa d'atenció domiciliaria (ATDOM),
               en què s'ha valorat la dependència, l'estat cognitiu (test Pfeiffer o qualsevol altre test que avaluï l'estat cognitiu) i el risc social, 
               o bé que s'hagi avaluat la complexitat, com a mínim, una vegada durant el període d'avaluació.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població assignada a l'EAP de 75 anys i més atesa al programa ATDOM"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada a l'EAP de 75 anys i més"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Estació Clínica d'Atenció Primària (ECAP).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCRE04" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Percentatge de la població que ha estat atesa per un centre de salut mental infantil i juvenil (CSMIJ) i d'adults (CSMA). 
               S'entén com a persona atesa aquella que s'ha visitat almenys un cop durant l'any seleccionat en qualsevol centre de salut mental (CSMA/CSMIJ).",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Nombre de persones que han estat ateses en un CSMIJ/CSMA"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe, ABS i grups d'edat (0-17 anys i 18 anys i més).",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Conjunt mínim bàsic de dades (CMBD).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCRE05" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Percentatge de població atesa que se'ls ha prescrit tractament amb el fàrmac seleccionat durant l'any seleccionat. Els fàrmacs seleccionats inclouen antidiabètics orals, 
               hipocolesterolemiants, antipsicòtics, antidepressius i antibiòtics. Cada grup de fàrmacs està destinat a tractar condicions específiques: els antidiabètics orals per a la diabetis; 
               els hipocolesterolemiants per al colesterol alt; els antipsicòtics per a trastorns mentals greus; els antidepressius per a la depressió; i els antibiòtics per a infeccions bacterianes.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població consumidora que se'ls ha prescrit tractament amb el fàrmac seleccionat"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada i atesa"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("Facturació, Registre Central d'Assegurats (RCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCRE06" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Percentatge de població atesa que se'ls ha prescrit tractament amb el psicofàrmac seleccionat durant l'any seleccionat.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població consumidora que se'ls ha prescrit tractament amb el psicofàrmac seleccionat"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada i atesa"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("SIRE, Registre Central d'Assegurats (RCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           ),
           
           "fitxa_SCRE07" = div(
             h2(icon("pencil", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Descripció", class = "title-style", style = "margin-top: 0px;"),
             p("Percentatge de població assignada a un equip d'atenció primària (EAP) que tenen 10 o més medicaments (ATC) diferents prescrits amb una vigència igual o superior a 3 mesos.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calculator", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Fórmula", class = "title-style"),
             div(
               class = "formula-container",
               div(
                 class = "fraction",
                 div(
                   class = "fraction-top",
                   "Població assignada amb 10 o més ATC diferents prescrits amb una vigència igual o superior a 3 mesos"
                 ),
                 div(
                   class = "fraction-bottom",
                   "Població assignada"
                 )
               ),
               "× 100"
             ),
             
             h2(icon("people-group", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Criteris tècnics", class = "title-style"),
             p("Disponible per sexe i ABS.",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("calendar", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Període", class = "title-style"),
             p("2022",
               style = "margin-bottom: 20px; text-align: justify;"),
             
             h2(icon("database", style = "color: #5EAEFF; margin-right: 10px; font-size: 24px;"), 
                "Origen de les dades", class = "title-style"),
             p("SIRE, Registre Central d'Assegurats (RCA).",
               style = "margin-bottom: 0px; text-align: justify;")
           )
           
    )
  })
  
}

################################################################################

# Execució de la Shiny app
shinyApp(ui = ui, server = server)
