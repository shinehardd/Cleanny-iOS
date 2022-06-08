//
//  RecordView.swift
//  Cleanny
//
//  Created by 종건 on 2022/06/08.
//


import SwiftUI

struct RecordView: View {
    @Environment(\.calendar) var calendar
     
    private var year: DateInterval {
          calendar.dateInterval(of: .month, for: Date())!
      }
    
    var body: some View {
      
        
          VStack{
            CalendarView(interval: self.year) { date in
                    Text("30")
                        .hidden()
                        .padding(8)
                        .background(1 != 1 ? Color.red : Color.blue) // Make your logic
                        .clipShape(Rectangle())
                        .cornerRadius(4)
                        .padding(4)
                        .overlay(
                            Text(String(self.calendar.component(.day, from: date)))
                                .foregroundColor(Color.black)
                                .underline(2 == 2) //Make your own logic
                        )
            }
            Spacer()
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
