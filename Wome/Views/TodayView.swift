//
//  TodayView.swift
//  Wome
//
//  Created by Larissa Barra Conde on 09/02/2021.
//

import SwiftUI

struct TodayView: View {
  static let dateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    return formatter
  }()
  
  let onComplete: (Measurement<UnitTemperature>, Date) -> Void
  let today = Date()
  
  @State var temperatureUnit: UnitTemperature = UnitTemperature.celsius
  @State var temperatureTime: Date = Date()
  @State var temperature: Double = 36.0
  // TODO find a way use Measurement
//  @State var temperature: Measurement<UnitTemperature> = Measurement(value: 36.0, unit: UnitTemperature.celsius)
  
  var temperatureProxy: Binding<String> {
    Binding<String>(
      get: {
        String(format: "%.2f", self.temperature)
      },
      set: {
        if let value = NumberFormatter().number(from: $0) {
          self.temperature = value.doubleValue
        }
      }
    )
  }
  
  var body: some View {
    Form {
      Section{
        Text("Today is \(today, formatter: Self.dateFormat)" )
      }
      Section(header: Text("Temperature")) {
        HStack {
          TextField("Temperature", text: temperatureProxy)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
          Picker("Unit", selection: $temperatureUnit) {
            Text(UnitTemperature.celsius.symbol).tag(UnitTemperature.celsius)
            Text(UnitTemperature.fahrenheit.symbol).tag(UnitTemperature.fahrenheit)
          }
          .pickerStyle(SegmentedPickerStyle())
          .onChange(of: temperatureUnit) { unit in
            var u: UnitTemperature
            if unit.symbol == UnitTemperature.celsius.symbol {
              u = UnitTemperature.fahrenheit
            } else {
              u = UnitTemperature.celsius
            }
            self.temperature = Measurement(value: self.temperature, unit: u).converted(to: unit).value
          }
        }
        
        DatePicker(
          "Measurement time:",
          selection: $temperatureTime,
          displayedComponents: .hourAndMinute)
        
        HStack {
          Spacer()
          Button("Save") {
            hideKeyboard()
            addTemperature()
          }
        }
      }
      Text("\(temperature)")
    }
  }
  
  private func addTemperature() {
    onComplete(
      Measurement(value: self.temperature, unit: self.temperatureUnit),
      temperatureTime
    )
  }
}

#if canImport(UIKit)
extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
#endif
