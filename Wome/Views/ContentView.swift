//
//  ContentView.swift
//  Wome
//
//  Created by Larissa Barra Conde on 08/02/2021.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  
  @FetchRequest<Temperature>(
    entity: Temperature.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \Temperature.measurementTime, ascending: true)
    ]
  ) var temperatures
  
  @State private var tabSelection = 0
  
  var body: some View {
    TabView(selection: $tabSelection) {
      TodayView(onComplete: { temperature, time in
        self.addTemperature(temperature, time)
      })
      .tabItem {
        Label("Today", systemImage: "thermometer")
      }
      .tag(0)
      
      ChartView(temps: temperatures)
      .tabItem {
        Label("Chart", systemImage: "calendar")
      }
      .tag(1)
    }
  }
  
  func addTemperature(_ temperature: Measurement<UnitTemperature>, _ time: Date) {
    let newTemp = Temperature(context: managedObjectContext)
    
    newTemp.valueCelcius = temperature.converted(to: UnitTemperature.celsius).value
    newTemp.valueFahrenheit = temperature.converted(to: UnitTemperature.fahrenheit).value
    newTemp.measurementTime = time
    
    saveContext()
  }
  
  func saveContext() {
    do {
      try managedObjectContext.save()
    } catch {
      print("Error saving managed object context: \(error)")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


