//
//  Drops
//
//  Copyright (c) 2021-Present Omar Albeik - https://github.com/omaralbeik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import SwiftUI
import Drops

struct ContentView: View {
  
  @State var title: String = "Hello There!"
  @State var subtitle: String = "Use Drops to show alerts"
  @State var positionIndex: Int = 0
  @State var duration: TimeInterval = 2.0
  @State var hasIcon: Bool = false
  @State var hasActionIcon: Bool = false
  
  var body: some View {
    ZStack {
      Color(.secondarySystemBackground).ignoresSafeArea(.all)
      VStack(alignment: .center, spacing: 20) {
        VStack {
          HStack {
            Text("Title").font(.caption)
            Spacer()
          }
          TextField("Title", text: $title).textFieldStyle(RoundedBorderTextFieldStyle())
        }
        VStack {
          HStack {
            Text("Optional Subtitle").font(.caption)
            Spacer()
          }
          TextField("Subtitle", text: $subtitle).textFieldStyle(RoundedBorderTextFieldStyle())
        }
        VStack {
          HStack {
            Text("Position").font(.caption)
            Spacer()
          }
          Picker(selection: $positionIndex, label: Text("Position")) {
            Text("Top").tag(0)
            Text("Bottom").tag(1)
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        VStack {
          HStack {
            Text("Duration (\(String(format: "%.1f", duration)) s)").font(.caption)
            Spacer()
          }
          Slider(value: $duration, in: 0.1...10)
        }
        Toggle("Icon", isOn: $hasIcon)
        Toggle("Button", isOn: $hasActionIcon)
        Spacer()
        Button(action: {
          showDrop()
        }, label: {
          Text("Show Drop")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(10)
        })
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(7.5)
      }
      .padding()
      .padding(.top, 80)
    }
    .ignoresSafeArea(.keyboard)
    .onTapGesture {
      UIApplication.shared.endEditing()
    }
  }
  
  private func showDrop() {
    UIApplication.shared.endEditing()
    
    let aTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
    let aSubtitle = subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
    let position: Drop.Position = positionIndex == 0 ? .top : .bottom
    
    let icon = hasIcon ? UIImage(systemName: "star.fill") : nil
    let buttonIcon = hasActionIcon ? UIImage(systemName: "arrowshape.turn.up.left") : nil
    
    let drop = Drop(
      title: aTitle,
      subtitle: aSubtitle,
      icon: icon,
      action: .init(icon: buttonIcon, handler: {
        print("Drop tapped")
        Drops.hideCurrent()
      }),
      position: position,
      duration: .seconds(duration)
    )
    Drops.show(drop)
  }
}

private extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
