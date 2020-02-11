//
//  TutorialUtil.swift
//  BackGroundVideoSample
//
//  Created by rMac on 2020/02/10.
//  Copyright © 2020 naipaka. All rights reserved.
//

internal class TutorialUtil {
    internal static let shared = TutorialUtil()

    /// 説明のタイトル
    private let introductionTitle = "ダウンロードありがとうございます！"
    private let settingPointsTitle = "基準となる場所の設定"
    private let setPinTitle = "見たい地点を探す"
    private let spotTitle = "スポットを探す"
    private let myPageTitle = "お気に入りと履歴"
    private let conclusionTitle = "説明は以上です！"

    /// 説明
    private let introductionDescription = "・これから使い方を説明していくよ！\n・説明をスキップしたい方は右上のスキップボタンを押してね！\n・説明は設定からいつでも見返せるよ！"
    private let settingPointsDescription = "・まずは中間地点の基準となる場所を設定！\n・現在地から設定したり、友達の最寄駅を登録しておくことも可能！\n・最大10地点まで設定できる！"
    private let setPinDescription = "・設定完了すると中間地点にピンが設置される！\n・ピンは移動可能！好きに移動してみよう！\n・ピンの位置を他の人に共有できる！"
    private let spotDescription = "・ピンの位置付近のスポット一覧が表示！\n・場所が気に入ったらいつでも見返せるようお気に入り登録！\n・飲食店・宿泊施設はそのまま予約することもできる！"
    private let myPageDescription = "・お気に入りはマイページから！\n・検索した履歴もここで確認できる！"
    private let conclusionDescription = "・新たなスポットを探しに行こう！\n\n"

    /// 説明文を取得
    /// - Parameter pageType: 説明の種類
    internal func getTutorialText(pageType: PageType) -> (String, String) {
        switch pageType {
        case .intoroduction:
            return (introductionTitle, introductionDescription)

        case .settingPoints:
            return (settingPointsTitle, settingPointsDescription)

        case .setPin:
            return (setPinTitle, setPinDescription)

        case .spot:
            return (spotTitle, spotDescription)

        case .myPage:
            return (myPageTitle, myPageDescription)

        case .conclusion:
            return (conclusionTitle, conclusionDescription)
        }
    }
}

internal enum PageType: String, CaseIterable {
    case intoroduction  // はじめに
    case settingPoints  // 基準となる地点の設定
    case setPin         // ピンの設置
    case spot           // スポット
    case myPage         // マイページ
    case conclusion     // 終わりに
}
