library(shiny)

introduction_page <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
  p("Humans must have a healthy environment to survive in this world. However, a number of variables could increase 
    the CO2 rate and result in the greenhouse gas effect. Greenhouse gas emissions are harmful to the environment because 
    they retain heat and may cause climate change. Our World in Data is a project started by Global Change Data Lab that 
    collects information on various global issues, including the dataset we'll be looking at, which is information on carbon
    dioxide (CO2) and greenhouse gas emissions."),
  textOutput("value1"),
  br(),
  img(src="gas.jpg", height = 500, width = 600)
)

plot_page <- tabPanel(
  "CO2 Level Plot",
  titlePanel("CO2 Over The Years"),
  sidebarPanel(
    uiOutput("pickCountry"),
    uiOutput("yearRange"),
    uiOutput("graphType")
  ),
  mainPanel(
    plotOutput("showPlot"),
    p("This visualization displays the Carbon Dioxide (CO2) Levels in million tonnes over the year (1750-2021). The earliest data collected was
      1750 and the most recent one is in 2021. However, we can only trace the CO2 levels since the 1750 for certain countries. 
      While different country has own fluctuations, we can see one prominent pattern which is the significant CO2 increase
       in 1950. Then, the CO2 levels decreased or stayed the same around 2000 for most countries. In most countries, 
       the highest CO2 levels is in 2021. The dramatic increase of CO2 leves in 1950 are caused by many stuffs. 
      However, NOAA mentioned that the burning of fossil fuels in order to make steel, electricity,
      and also oil that are used for vehicles and manufacturing. I decided to 
      include this visualization to raise awareness that our climate ondition is getting worse. We should start reducing emissions by reduce fossil fuels use, 
      use renewable powers, and be more energy efficient. Aside from that, this can also be a reference to policy makers to 
      make strict rules regarding fossil fuels project and usage."),
  )
)

ui <- navbarPage(
  "Climate Change",
  introduction_page,
  plot_page
)