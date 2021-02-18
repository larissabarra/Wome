//
//  ChartView.swift
//  Wome
//
//  Created by Larissa Barra Conde on 10/02/2021.
//

import SwiftUI

struct ChartView: View {
  var temperatures: FetchedResults<Temperature>
  var cycleLength = 28
  
  @State var temperatureUnit: UnitTemperature = UnitTemperature.celsius
  @State var zoom: CGFloat = 1
  
  var max: Double {
    get {
      if temperatureUnit.symbol == UnitTemperature.celsius.symbol {
        return 37.5
      }
      return 99.0
    }
  }
  
  var min: Double {
    get {
      if temperatureUnit.symbol == UnitTemperature.celsius.symbol {
        return 36.0
      }
      return 97.0
    }
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Picker("Unit", selection: $temperatureUnit) {
          Text(UnitTemperature.celsius.symbol).tag(UnitTemperature.celsius)
          Text(UnitTemperature.fahrenheit.symbol).tag(UnitTemperature.fahrenheit)
        }
        .pickerStyle(SegmentedPickerStyle())
        Spacer()
        
        ScrollView(.horizontal) {
          ZStack {
            Grid(min: self.min, max: self.max, length: self.cycleLength)
              .stroke(Color.gray.opacity(0.5), lineWidth: 1)
              .frame(width: geometry.size.width * self.zoom - 34,
                     height: geometry.size.width * 9 / 16,
                     alignment: .center)
              .aspectRatio(contentMode: .fit)
            LineGraph(dataPoints: temperatureData(unit: temperatureUnit), length: self.cycleLength)
              .stroke(Color.red, lineWidth: 2)
              .frame(width: geometry.size.width * self.zoom - 34,
                     height: geometry.size.width * 9 / 16,
                     alignment: .center)
              .aspectRatio(contentMode: .fit)
              .border(Color.accentColor, width: 1)
          }
        }
        
        Slider(value: $zoom, in: 1...3, step: 1)
      }
      .padding()
    }
  }
  
  private func temperatureData(unit: UnitTemperature) -> [CGFloat] {
    var data: [CGFloat] = []
    
    for temp in temperatures {
      let temperature = unit == UnitTemperature.celsius ? temp.valueCelcius : temp.valueFahrenheit
      data.append(CGFloat(normalise(val: temperature, max: max, min: min)))
    }
    
    return data
  }
  
  private func normalise(val: Double, max: Double, min: Double) -> Double {
    return (val - min) / (max - min)
  }
}

struct Grid: Shape {
  var min: Double
  var max: Double
  var length: Int
  
  func path(in rect: CGRect) -> Path {
    return Path { path in
      let steps = Int((max-min) / 0.1)
      for i in 0..<steps {
        let y = rect.height * CGFloat(i) / CGFloat(steps)
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: rect.width, y: y))
      }
      
      for i in 0..<length {
        let x = rect.width * CGFloat(i) / CGFloat(length)
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: rect.height))
      }
    }
  }
}

struct LineGraph: Shape {
  var dataPoints: [CGFloat]
  var length: Int
  
  func path(in rect: CGRect) -> Path {
    func point(at ix: Int) -> CGPoint {
      let point = dataPoints[ix]
      let x = rect.width * CGFloat(ix) / CGFloat(length)
      let y = (1-point) * rect.height
      return CGPoint(x: x, y: y)
    }
    
    return Path { p in
      guard dataPoints.count > 1 else { return }
      let start = dataPoints[0]
      p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
      for idx in dataPoints.indices {
        p.addLine(to: point(at: idx))
      }
    }
  }
}



