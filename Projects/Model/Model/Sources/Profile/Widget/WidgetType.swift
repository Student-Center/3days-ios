//
//  WidgetType.swift
//  Model
//
//  Created by 김지수 on 11/10/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import SwiftUI
import CoreKit
import OpenapiGenerated

public enum WidgetType: CaseIterable {
    case hobby
    case style
    case mbti
    case music
    case body
    case food
    case movie
    case drama
    case book
    case travel
    case alcohol
    case marriage
    case religion
    case smoking
}

extension WidgetType {
    public var title: String {
        switch self {
        case .hobby: return "취미"
        case .style: return "스타일"
        case .mbti: return "MBTI"
        case .music: return "음악"
        case .body: return "키·체형"
        case .food: return "음식"
        case .movie: return "영화"
        case .drama: return "드라마"
        case .book: return "책"
        case .travel: return "여행"
        case .alcohol: return "술"
        case .marriage: return "결혼관"
        case .religion: return "종교"
        case .smoking: return "흡연"
        }
    }
    
    public var emoji: String {
        switch self {
        case .hobby: return "🏃"
        case .style: return "👖"
        case .mbti: return "💭"
        case .music: return "🎧"
        case .body: return "💪"
        case .food: return "🍔"
        case .movie: return "🎬"
        case .drama: return "📺"
        case .book: return "📚"
        case .travel: return "✈️"
        case .alcohol: return "🍷"
        case .marriage: return "💍"
        case .religion: return "⛪"
        case .smoking: return "🚬"
        }
    }
    
    public var exampleText: String {
        switch self {
        case .hobby:
            return "ex.\n테니스랑 헬스 즐겨해요! 같이 하실 분?"
        case .style:
            return "ex.\n옷은 깔끔하게 흰 티에 청바지만 입는 게 진리입니다"
        case .mbti:
            return "ex.\n저는 INTP지만 연애할 때는 F 100%가 된답니다"
        case .music:
            return "ex.\nFly to me the moon이 제 인생곡이에요!"
        case .body:
            return "ex.\n키는 180이구 헬스 하면서 어깨 키우고 있어요☺️"
        case .food:
            return "ex.\n음식 가리는 거 없이 거의 다 잘 먹어요!"
        case .movie:
            return "ex.\n제 인생 영화는 비긴 어게인이에용"
        case .drama:
            return "ex.\n하츠코이, 언내추럴 같은 일드 취향👀"
        case .book:
            return "ex.\nIT 관련 서적이나 자기계발서 위주로 봐요"
        case .travel:
            return "ex.\n아이슬란드처럼 대자연의 낭만이 있는 곳으로 가보고 싶어요.."
        case .alcohol:
            return "ex.\n화이트 와인, 하이볼, 칵테일을 좋아하는 술찌입니다😇"
        case .marriage:
            return "ex.\n마음만 맞으면 결혼 자금이나 시기는 조율할 수 있다고 생각해요!"
        case .religion:
            return "ex.\n저와 우리 집안 모두 무교입니다!"
        case .smoking:
            return "ex.\n전자담배만 피워요 ! 담배냄새는 저도 싫어합니다 ㅜ"
        }
    }
}

extension WidgetType {
    public var toDto: Components.Schemas.ProfileWidgetType {
        switch self {
        case .hobby: .HOBBY
        case .style: .STYLE
        case .mbti: .MBTI
        case .music: .MUSIC
        case .body: .BODY_TYPE
        case .food: .FOOD
        case .movie: .MOVIE
        case .drama: .DRAMA
        case .book: .BOOK
        case .travel: .TRAVEL
        case .alcohol: .DRINKING
        case .marriage: .MARRIAGE
        case .religion: .RELIGION
        case .smoking: .SMOKING
        }
    }
    
    init(from dto: Components.Schemas.ProfileWidgetType) {
        switch dto {
        case .HOBBY: self = .hobby
        case .STYLE: self = .style
        case .MBTI: self = .mbti
        case .MUSIC: self = .music
        case .BODY_TYPE: self = .body
        case .FOOD: self = .food
        case .MOVIE: self = .movie
        case .DRAMA: self = .drama
        case .BOOK: self = .book
        case .TRAVEL: self = .travel
        case .DRINKING: self = .alcohol
        case .MARRIAGE: self = .marriage
        case .RELIGION: self = .religion
        case .SMOKING: self = .smoking
        }
    }
}
