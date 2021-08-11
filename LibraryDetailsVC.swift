
import UIKit

class LibraryDetailsVC: BaseVC {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - Class Variables -
    
    var dataObject: [VideoLibraryModel2]?
    var titleCategory = ""
    
    //--------------------------------------------------------------------------------------

    //MARK: - Action Methods -
    
    @IBAction func backTapHandler(button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //--------------------------------------------------------------------------------------
   
    //MARK: - View Life Cycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleCategory
        collectionView.registerCell(CategoryCVCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //--------------------------------------------------------------------------------------    
    
    // MARK: - Collection view delegate

extension LibraryDetailsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let vc = Home.VC(.Video) as! VideoVC
        vc.model = dataObject?[indexPath.row]
        vc.mainTitle = titleCategory
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        nvc.isNavigationBarHidden = true
        tabBarController?.present(nvc, animated: true, completion: nil)
    }
}

    // MARK: - Collection view data source

extension LibraryDetailsVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataObject?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.reusableCell(CategoryCVCell.self, indexPath)
        cell.categoryObject = dataObject?[indexPath.row]
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var totalHeight: CGFloat = (self.view.frame.width / 10000)
//        var totalWidth: CGFloat = (self.view.frame.width / 10000)
//        return CGSize(width: ceil(totalWidth), height: ceil(totalHeight))
//    }
    
}

extension LibraryDetailsVC: UICollectionViewDelegateFlowLayout {
    /*
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 325 + 10, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    }
    */
}

