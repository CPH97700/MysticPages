//
//  TabEnum.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 27.03.25.
//


//
//  TabEnum.swift
//  Quotely
//
//  Created by Isabell Philippi on 04.02.25.
//
import Foundation
import SwiftUI
import SwiftUICore

enum TabEnum: String, CaseIterable, Identifiable {
    case home, journal, quotes, settings

    var id: String { rawValue }

    func tabView(viewModel: HomeViewModel) -> some View {
        switch self {
        case .home:
            return AnyView(HomeView(viewModel: viewModel))
        case .journal:
            return AnyView(DiaryView(viewModel: viewModel))
        case .quotes:
            return AnyView(LocalQuoteOfTheDayView())
        case .settings:
            return AnyView(SettingsView())
        }
    }

    var title: String {
        switch self {
        case .home: return "Blind Date"
        case .journal: return "Tagebuch"
        case .quotes: return "Zitate"
        case .settings: return "Einstellungen"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .journal: return "chart.bar"
        case .quotes: return "quote.bubble"
        case .settings: return "gearshape"
        }
    }
}
