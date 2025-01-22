# Install necessary packages if not already installed
if (!requireNamespace("caret", quietly = TRUE)) install.packages("caret")
if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny")
if (!requireNamespace("shinythemes", quietly = TRUE)) install.packages("shinythemes")
if (!requireNamespace("pROC", quietly = TRUE)) install.packages("pROC")
library(shiny)
library(shinythemes)

library(shiny)
library(shinythemes)

# Load the trained model
best_model <- readRDS("best_model.rds")

# UI
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  navbarPage(
    title = "Diabetes Risk Prediction App for Women",
    tabPanel(
      "Prediction",
      sidebarLayout(
        sidebarPanel(
          h4("Enter Your Details"),
          p("Note: This app is designed only for women."),
          
          # Name Input
          textInput("name", "Enter Your Name", placeholder = "Your Name"),
          
          # Age Input
          numericInput("age", "Age (years)", value = 30, min = 18, max = 99),
          p("Age range: 18–99 years."),
          
          # Pregnancies Input
          numericInput("pregnancies", "Number of Pregnancies", value = 0, min = 0, max = 15),
          p("Enter the number of pregnancies (maximum 15)."),
          
          # Glucose Input
          sliderInput("glucose", "Glucose Level (mg/dL)", min = 0, max = 200, value = 100),
          p("The glucose level represents the amount of sugar in your blood. Normal fasting glucose levels are between 70 and 100 mg/dL."),
          
          # Blood Pressure Input
          sliderInput("blood_pressure", "Blood Pressure (mmHg)", min = 0, max = 150, value = 80),
          p("Blood pressure measures the force of blood against your artery walls. Normal blood pressure is around 120/80 mmHg."),
          
          # Skin Thickness Input
          sliderInput("skin_thickness", "Skin Thickness (mm)", min = 0, max = 100, value = 20),
          p("Skin thickness measures the thickness of skin folds as an indicator of body fat. Typically, it ranges around 20-30 mm."),
          
          # Insulin Input
          sliderInput("insulin", "Insulin Level (μU/mL)", min = 0, max = 300, value = 85),
          p("Insulin regulates blood sugar levels. Normal fasting insulin levels range between 5 and 15 μU/mL."),
          
          # BMI Calculator
          fluidRow(
            column(6,
                   numericInput("bmi", "BMI (kg/m²)", value = 25, min = 0, max = 70, step = 0.1),
                   p("BMI indicates body fat based on weight and height. A normal BMI is between 18.5 and 24.9.")
            ),
            column(6,
                   h4("BMI Calculator"),
                   numericInput("weight", "Weight (kg)", value = 70, min = 1, step = 0.1),
                   numericInput("height", "Height (cm)", value = 170, min = 50, step = 0.1),
                   actionButton("calculate_bmi", "Calculate BMI"),
                   verbatimTextOutput("calculated_bmi"),
                   p("Note: BMI is calculated as weight in kilograms divided by the square of height in meters (kg/m²).")
            )
          ),
          
          # Diabetes Pedigree Function Calculator
          h4("Diabetes Pedigree Function Calculator"),
          numericInput("immediate_relatives", "Immediate Relatives with Diabetes", value = 0, min = 0, max = 10),
          numericInput("extended_relatives", "Extended Relatives with Diabetes", value = 0, min = 0, max = 20),
          actionButton("calculate_dpf", "Calculate DPF"),
          verbatimTextOutput("calculated_dpf"),
          numericInput("pedigree", "Diabetes Pedigree Function", value = 0.5, min = 0, max = 2.5, step = 0.01),
          p("The Diabetes Pedigree Function estimates the likelihood of diabetes based on family history. A higher value indicates greater risk."),
          
          # Prediction Button
          actionButton("predict_btn", "Predict Diabetes Risk")
        ),
        mainPanel(
          h3("Prediction Result"),
          uiOutput("formatted_result"),  # Formatted prediction result
          uiOutput("personalized_tip"),  # Personalized tip
          plotOutput("riskPlot", height = "300px")  # Bar Chart
        )
      )
    ),
    tabPanel(
      "Educational Content",
      fluidPage(
        h2("Understanding and Preventing Diabetes"),
        p("Diabetes is a chronic condition that affects millions worldwide. With awareness and action, you can minimize your risk. Here’s what you should know:"),
        
        h3("Did You Know?"),
        tags$ul(
          tags$li("Diabetes is one of the leading causes of kidney failure and blindness worldwide."),
          tags$li("Nearly 1 in 10 adults worldwide has diabetes, and the number is increasing every year."),
          tags$li("Type 2 diabetes accounts for approximately 90% of diabetes cases."),
          tags$li("With the right lifestyle choices, up to 50% of Type 2 diabetes cases can be prevented.")
        ),
        
        h3("Prevention Tips:"),
        tags$ul(
          tags$li("Maintain a balanced diet rich in fruits, vegetables, whole grains, and lean proteins."),
          tags$li("Exercise regularly for at least 150 minutes per week, including activities like walking, swimming, or cycling."),
          tags$li("Avoid sugary drinks and processed foods to prevent blood sugar spikes."),
          tags$li("Drink enough water to stay hydrated and support overall health."),
          tags$li("Manage stress levels with techniques like yoga, meditation, or deep breathing exercises."),
          tags$li("Get enough sleep, as poor sleep can increase the risk of diabetes.")
        ),
        
        h3("What to Do If You’re at Risk:"),
        tags$ul(
          tags$li("Schedule regular check-ups with your healthcare provider."),
          tags$li("Monitor your blood sugar levels and keep a record."),
          tags$li("Seek early intervention if you notice symptoms like frequent urination, extreme thirst, or fatigue."),
          tags$li("Consider joining a diabetes prevention program for support and guidance.")
        ),
        
        h3("Resources for Further Learning:"),
        tags$ul(
          tags$li(a("American Diabetes Association", href = "https://www.diabetes.org", target = "_blank")),
          tags$li(a("World Health Organization (Diabetes Facts)", href = "https://www.who.int/health-topics/diabetes", target = "_blank")),
          tags$li(a("Centers for Disease Control and Prevention (Diabetes Prevention)", href = "https://www.cdc.gov/diabetes/prevention/index.html", target = "_blank"))
        ),
        
        h3("Meet the Developer:"),
        p("Hi! I'm Kiran, the developer of this app. I am passionate about using data to make a difference, whether it's helping individuals monitor their health or empowering organizations to make data-driven decisions."),
        p("Feel free to connect with me on LinkedIn:"),
        p(a("Kiran Chakkapally - LinkedIn", href = "https://www.linkedin.com/in/kiran-chakkapally/", target = "_blank"))
      )
    )
    
  )
)

# Server
server <- function(input, output, session) {
  
  # Calculate BMI
  observeEvent(input$calculate_bmi, {
    height_m <- input$height / 100
    bmi <- round(input$weight / (height_m^2), 1)
    output$calculated_bmi <- renderText({
      paste("Your calculated BMI is:", bmi)
    })
  })
  
  # Calculate Diabetes Pedigree Function
  observeEvent(input$calculate_dpf, {
    dpf <- round((0.7 * input$immediate_relatives + 0.3 * input$extended_relatives) / 10, 2)
    output$calculated_dpf <- renderText({
      paste("Your calculated Diabetes Pedigree Function is:", dpf)
    })
    updateNumericInput(session, "pedigree", value = dpf)
  })
  
  # Predict Diabetes Risk
  observeEvent(input$predict_btn, {
    user_data <- data.frame(
      Name = input$name,
      Age = input$age,
      Pregnancies = input$pregnancies,
      Glucose = input$glucose / 200,
      BloodPressure = input$blood_pressure / 150,
      SkinThickness = input$skin_thickness / 100,
      Insulin = input$insulin / 300,
      BMI = input$bmi / 70,
      DiabetesPedigreeFunction = input$pedigree
    )
    prediction <- predict(best_model, user_data, type = "prob")
    risk <- round(prediction$Yes * 100, 2)
    
    # Formatted Result in Desired Style
    output$formatted_result <- renderUI({
      div(
        style = "padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9; margin-bottom: 10px;",
        h4(ifelse(risk > 50, "High Risk of Diabetes", "Low Risk of Diabetes"), 
           style = "color: #007bff;"),
        p(paste0("(", risk, "% probability)"), style = "font-size: 14px; color: #555;")
      )
    })
    
    # Personalized Tip
    output$personalized_tip <- renderUI({
      div(
        style = "padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;",
        p(ifelse(
          risk > 50,
          "Consider consulting a healthcare provider soon. Make healthy lifestyle changes immediately.",
          "Maintain your healthy lifestyle and stay active to keep the risk low."
        ), style = "font-size: 14px; color: #555;")
      )
    })
    
    # Bar Chart Visualization
    output$riskPlot <- renderPlot({
      barplot(
        c(100 - risk, risk),
        names.arg = c("No Diabetes", "Diabetes"),
        col = c("green", "red"),
        main = "Diabetes Risk Prediction",
        ylab = "Probability (%)"
      )
    })
  })
}

# Run the app
shinyApp(ui, server)
