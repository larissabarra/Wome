//
//  ChartView.swift
//  Wome
//
//  Created by Larissa Barra Conde on 10/02/2021.
//

import SwiftUI

struct ChartView: View {
  var temps: FetchedResults<Temperature>
  var index = 0
  
  var body: some View {
    Path { path in
      path.move(to: CGPoint(x: 20, y: 20))
//      for temp in temps {
//        self.index = self.index + 1
//        path.addLine(to: CGPoint(x: ((self.index * 20) + 40), y: temp.value))
//      }
    }
  }
}

