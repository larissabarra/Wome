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
  
  var numberFormat: String {
    get {
      if temperatureUnit.symbol == UnitTemperature.celsius.symbol {
        return "%.2f"
      }
      return "%.1f"
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
        
        ScrollView(.horizontal) {
          VStack(alignment: .trailing, spacing: 2) {
            HStack(spacing: 2){
              VStack(spacing: 0) {
                ForEach(Array(stride(from: max, to: min - 0.1, by: -0.1)), id: \.self) { num in
                  Text(String(format: self.numberFormat, num))
                    .foregroundColor(Color.gray)
                    .font(.caption2)
                    .frame(height: (geometry.size.width * 9 / 16) / CGFloat(self.temperatureUnit.symbol == UnitTemperature.celsius.symbol ? 15 : 20))
                }
              }
              
              ZStack {
                Grid(min: self.min, max: self.max, length: self.cycleLength)
                  .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                  .frame(width: geometry.size.width * 1.1 * self.zoom,
                         height: geometry.size.width * 9 / 16)
                  .aspectRatio(contentMode: .fit)
                
                LineGraph(dataPoints: temperatureData(unit: temperatureUnit), length: self.cycleLength)
                  .stroke(Color.red, lineWidth: 2)
                  .frame(width: geometry.size.width * 1.1 * self.zoom,
                         height: geometry.size.width * 9 / 16)
                  .aspectRatio(contentMode: .fit)
                  .border(Color.accentColor, width: 1)
              }
            }
            
            HStack(spacing: 0) {
              ForEach((1...self.cycleLength), id: \.self) {
                Button("\($0)") {
                  //action
                }
                .rotationEffect(.degrees(-45))
                .font(.caption2)
                .lineLimit(1)
                .frame(width: (geometry.size.width * 1.1 * self.zoom) / CGFloat(self.cycleLength))
              }
            }
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
        let pt = point(at: idx)
        p.addLine(to: pt)
      }
    }
  }
}



