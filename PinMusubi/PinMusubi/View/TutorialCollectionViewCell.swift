//
//  TutorialCollectionViewCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import SwiftyGif
import UIKit

public class TutorialCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var descriptionImageView: UIImageView!

    private var descriptionText = ""

    override public func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
    }

    public func configure(row: Int) {
        switch row {
        case 0:
            descriptionText = "まず、中間地点を求めるための\n基準となる場所を設定します\n\n最大10個まで設定できます！"
            descriptionImageView.image = UIImage(named: "Tutorial0.jpeg")

        case 1:
            descriptionText = "設定が完了すると設定場所の\n中間地点にピンが設置されます"
            descriptionImageView.image = UIImage(named: "Tutorial1.jpeg")

        case 2:
            descriptionText = "中間地点が気に入らなければ\nピンの移動も可能です！\n\nピンを長押しして浮かせてから\n移動させましょう！"
            descriptionImageView.image = UIImage(named: "Tutorial2.jpeg")

        case 3:
            descriptionText = "詳細を見るボタンを押すと\nスポット一覧を表示します\n\nこの場所が気に入ったら\nお気に入り登録しましょう！"
            descriptionImageView.image = UIImage(named: "Tutorial3.jpeg")

        case 4:
            descriptionText = "お気に入りとスポット検索履歴は\nマイページから確認できます"
            descriptionImageView.image = UIImage(named: "Tutorial4.jpeg")

        default:
            break
        }
        descriptionLabel.text = descriptionText
        guard let image = descriptionImageView.image else { return }
        let aspectScale = image.size.height / image.size.width
        let screenWidth = UIScreen.main.bounds.size.width
        let resizedSize = CGSize(width: screenWidth * 0.7, height: screenWidth * aspectScale * 0.7)
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        descriptionImageView.image = resizedImage
        descriptionImageView.layer.borderWidth = 1.0
        descriptionImageView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionImageView.layer.cornerRadius = 10
    }
}
