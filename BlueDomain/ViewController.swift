//
//  ViewController.swift
//  BlueDomain
//
//  Created by Faizyy on 25/03/20.
//  Copyright © 2020 faiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Constants
    fileprivate let kMinimumCellWidth: CGFloat = 55.0
    fileprivate let kDefaultCellPadding: CGFloat = 20

    
    let source = ["This","is","a","crocodile","man","made","elephant","anddfdsfsd"]
    let sourceOptions = ["Here","we","options","for","user","hence"]
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var optionsWordCollection: UICollectionView!
    @IBOutlet weak var selectedWordsCollection: UICollectionView!
    @IBOutlet weak var speaker: UIButton!
    @IBOutlet weak var foreignLanguageLabel: UILabel!
    
    
    func setupSpeakerButton() {
        speaker.layer.cornerRadius = 15
        speaker.layer.borderColor = UIColor.clear.cgColor
        speaker.layer.borderWidth = 1
        speaker.layer.masksToBounds = false
        speaker.layer.shadowOpacity = 0.9
        speaker.layer.shadowColor = UIColor.systemBlue.cgColor
        speaker.layer.shadowRadius = 0
        speaker.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func setupDelegateAndDatasource() {
        selectedWordsCollection.delegate = self
        selectedWordsCollection.dataSource = self
        selectedWordsCollection.isScrollEnabled = false
        optionsWordCollection.delegate = self
        optionsWordCollection.dataSource = self
        optionsWordCollection.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSpeakerButton()
        setupDelegateAndDatasource()
                
        optionsWordCollection.collectionViewLayout = CustomLayout()
        selectedWordsCollection.collectionViewLayout = CustomLayout()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == self.selectedWordsCollection ? self.source.count : self.sourceOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let datasource = collectionView.tag == 1 ? source : sourceOptions
        let cellId = collectionView.tag == 1 ? "cell1" : "cell2"
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WordCell
        
        cell.textLabel.text = datasource[indexPath.row]
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: datasource[indexPath.row]).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)

        cell.textLabel.frame = CGRect(x: 0, y: 0, width: estimatedFrame.width+kDefaultCellPadding, height: cell.textLabel.frame.height)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self.source[indexPath.row]).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)

        let finalWidth = estimatedFrame.width+kDefaultCellPadding < kMinimumCellWidth ? kMinimumCellWidth : estimatedFrame.width+kDefaultCellPadding
        
        return CGSize(width: finalWidth, height: 50)
        
    }
    
}

// For left aligned collection view cells.
class CustomLayout: UICollectionViewFlowLayout {

    required override init() {super.init(); common()}
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder); common()}

    private func common() {
//        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }

    override func layoutAttributesForElements(
                    in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let att = super.layoutAttributesForElements(in:rect) else {return []}
        var x: CGFloat = sectionInset.left
        var y: CGFloat = -1.0

        for a in att {
            if a.representedElementCategory != .cell { continue }

            if a.frame.origin.y >= y { x = sectionInset.left }
            a.frame.origin.x = x
            x += a.frame.width + minimumInteritemSpacing
            y = a.frame.maxY
        }
        return att
    }
}
