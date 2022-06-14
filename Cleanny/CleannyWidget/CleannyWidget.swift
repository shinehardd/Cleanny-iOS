//
//  CleannyWidget.swift
//  CleannyWidget
//
//  Created by 한경준 on 2022/06/13.
//

import WidgetKit
import SwiftUI

//Provider
//위젯의 업데이트 시기를 Widgetkit에 알려줌
struct Provider: TimelineProvider {
    //플레이스홀더
    //위젯이 타임라인을 기다리고 있을 때 보여주는 위젯의 기본값
    //사용자의 데이터가 들어가면 안 되고, 보통 텍스트 위치에 박스로 위젯의 형태를 나타낸다
    //동기식으로 즉각 반환하는 값을 넣어주자
    //크게 건드릴 필요 없이 자동으로 해주는듯
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    //스냅샷
    //getSnapshot: 위젯의 현재 시간과 상태를 나타내는 타임 라인 항목을 제공
    
    //여기서 context의 파라미터인 Context를 짚고 넘어가자
    //TimelineProviderContext는 크기 및 위젯 갤러리에 표시되는지 여부를 포함하여 위젯이 렌더링되는 방법에 대한 세부 정보가 포함 된 개체
    //isPreview: Bool = 위젯 갤러리인지 아닌지를 나타내는 Bool
    //family: Widgetfamily = widgetSize. [.systemSmall, .systemMedium, .systemLarge]
    //displaySize: CGSize = 위젯의 크기와 위치 확인
    //let environmentVariants: TimelineProviderContext.EnvironmentVariants = .colorScheme, .displayScale 등을 설정할 수 있음
    //이를 활용해 위젯이 어떤 상태인지 확인하고 각각 다른 컨텐츠를 제공해줄 수 있다.
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    //getTimeline
    //현재 시간 및 선택적으로 위젯을 업데이트 할 미래 시간에 대한 타임 라인 항목의 배열을 제공 = 홈에 가만히 있는 앱을 언제, 어떻게 업데이트할까를 구현하는 부분.
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date() //현재시간 불러옴
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)! //1시간씩 더함
            let entry = SimpleEntry(date: entryDate) //한시간씩 더한 값을 갖는 entry를 생성
            entries.append(entry) //entry 추가
        }

        let timeline = Timeline(entries: entries, policy: .atEnd) // entries을 갖는 Timeline을 생성
        // policy
        // - atEnd : 마지막 date가 끝난후 새로고침
        // - after(date) : date가 지난 후 새로고침
        completion(timeline) //Timeline 넘겨줌
        
        //4시간 후에는 타임라인을 다시 새로 불러와서 새로고침(위젯 업데이트 종료하는 것 아님)
    }
}

//Entry
//TimelineEntry: 위젯 표시할 날짜(date), 그 외 위젯에 나타나는 데이터
//date는 필수, 다른 데이터 추가 가능
struct SimpleEntry: TimelineEntry {
    let date: Date
    //var clean = CleaningDataStore()
}

//View
//MyWidgetEntryView: SwiftUI로 위젯 view 구성하는 부분
struct CleannyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        //여기다가 꾸미면 됨
        Text(entry.date, style: .time)
    }
}

@main
struct CleannyWidget: Widget {
    //kind: widgetcenter에서 타임라인을 reloading할 때 식별하는 문자열
    let kind: String = "CleannyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CleannyWidgetEntryView(entry: entry)
        }
        //위젯 이름(위젯 갤러리)
        .configurationDisplayName("My Widget")
        //위젯 설명(위젯 갤러리)
        .description("This is an example widget.")
        //지원하는 위젯 사이즈
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])

    }
}

//Preview
//
struct CleannyWidget_Previews: PreviewProvider {
    static var previews: some View {
        CleannyWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
