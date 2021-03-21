//
//  TemperatureIntentHandler.swift
//  WomeKit
//
//  Created by Larissa Barra Conde on 18/03/2021.
//

import Foundation
import Intents

class TemperatureIntentHandler: NSObject, LogTemperatureIntentHandling {
  let context = CoreDataStorage.mainQueueContext()
  
  func handle(intent: LogTemperatureIntent, completion: @escaping (LogTemperatureIntentResponse) -> Void) {
    print("meu intent")
    guard let temperature = intent.Temperature else {
      completion(LogTemperatureIntentResponse(code: .failure, userActivity: nil))
      return
    }
    addTemperature(temperature)
    completion(LogTemperatureIntentResponse(code: .success, userActivity: nil))
  }
  
  func resolveTemperature(for intent: LogTemperatureIntent, with completion: @escaping (LogTemperatureTemperatureResolutionResult) -> Void) {
    if let temperature = intent.Temperature, temperature.converted(to: .celsius).value >= 35 {
      completion(LogTemperatureTemperatureResolutionResult.success(with: temperature))
    } else {
      completion(LogTemperatureTemperatureResolutionResult.unsupported())
    }
  }
  
  func addTemperature(_ temperature: Measurement<UnitTemperature>) {
    let newTemp = Temperature(context: context)
    
    newTemp.valueCelcius = temperature.converted(to: UnitTemperature.celsius).value
    newTemp.valueFahrenheit = temperature.converted(to: UnitTemperature.fahrenheit).value
    newTemp.measurementTime = Date()
    
    CoreDataStorage.saveContext(self.context)
  }
}
