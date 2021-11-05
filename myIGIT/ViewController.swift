//
//  ViewController.swift
//  myIGIT
//
//  Created by Sambit Das on 27/01/1943 Saka.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    // MARK:- Constants
    
    struct Constants {
        enum TabName {
            static let home = "Home"
            static let homeIcon = "house.fill"
            static let note = "Note"
            static let noteIcon = "note.text"
            static let book = "Book"
            static let bookIcon = "books.vertical.fill"
            static let interview = "iOS"
            static let interviewIcon = "applelogo"
            static let gallery = "Gallery"
            static let galleryIcon = "photo.fill.on.rectangle.fill"
            static let about = "About"
            static let aboutIcon = "person.crop.square.fill.and.at.rectangle"
        }
        
        enum URLs {
            static let myigit = "https://iosdev.in"
            static let interviewQuestion = "https://iosdev.in/interviewQA.html"
            static let notes = "https://iosdev.in/mcanote.html"
            static let books = "https://iosdev.in/eBooks.html"
            static let gallery = "https://iosdev.in/gallery.html"
            static let about = "https://iosdev.in/aboutus.html"
        }
        
        enum Colors {
            static let primaryColor: UIColor = .systemGreen
            static let inactiveTab: UIColor = .lightGray
        }
    }
    
    // MARK:- Outlets ans Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tabDetails = [(String, String)]()
    var selectedTab = IndexPath(item: 0, section: 0)
    
    // MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        runActivityIndicator()
        setWebView()
    }
    
    //number of tab
    var numberOfTab: Int {
        tabDetails.removeAll()
        tabDetails.append((Constants.TabName.home, Constants.TabName.homeIcon))
        tabDetails.append((Constants.TabName.interview, Constants.TabName.interviewIcon))
        tabDetails.append((Constants.TabName.note, Constants.TabName.noteIcon))
        tabDetails.append((Constants.TabName.book, Constants.TabName.bookIcon))
        tabDetails.append((Constants.TabName.gallery, Constants.TabName.galleryIcon))
        tabDetails.append((Constants.TabName.about, Constants.TabName.aboutIcon))
        return tabDetails.count
    }
    
    // MARK:- Methods
    
    private func setWebView() {
        loadWebView(index: selectedTab)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.delegate = self
    }
    
    private func loadWebView(index: IndexPath) {
        var pageURL = Constants.URLs.myigit
        switch index {
        case IndexPath(item: 0, section: 0):
            pageURL = Constants.URLs.myigit
        case IndexPath(item: 1, section: 0):
            pageURL = Constants.URLs.interviewQuestion
        case IndexPath(item: 2, section: 0):
            pageURL = Constants.URLs.notes
        case IndexPath(item: 3, section: 0):
            pageURL = Constants.URLs.books
        case IndexPath(item: 4, section: 0):
            pageURL = Constants.URLs.gallery
        case IndexPath(item: 5, section: 0):
            pageURL = Constants.URLs.about
        default:
            pageURL = Constants.URLs.myigit
        }
        let url = URL(string: pageURL)
        let requestObj = URLRequest(url: url! as URL)
        webView.load(requestObj)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0) {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfTab
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarCollectionViewCell", for: indexPath) as? TabBarCollectionViewCell ?? TabBarCollectionViewCell()
        cell.tabName.text = tabDetails[indexPath.row].0
        cell.tabImage.image = UIImage(systemName: tabDetails[indexPath.row].1)
        cell.tabName.tintColor = .lightText
        if indexPath == selectedTab {
            cell.tabImage.tintColor = Constants.Colors.primaryColor
        } else {
            cell.tabImage.tintColor = Constants.Colors.inactiveTab
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(numberOfTab), height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

// MARK:- Manage TabSelection Logic

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateTabBar(index: indexPath)
        //print(webView.backForwardList.backList.count)
    }
    
    private func updateTabBar(index: IndexPath) {
        selectedTab = index
        loadWebView(index: selectedTab)
        runActivityIndicator()
        collectionView.reloadData()
    }
    
    private func runActivityIndicator() {
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.activityIndicator.stopAnimating()
        }
    }
}

