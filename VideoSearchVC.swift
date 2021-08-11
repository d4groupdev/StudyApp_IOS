
import UIKit

class VideoSearchVC: BaseVC {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - Class Variables -
    
    var videosData: [VideoDetailsModel] = []
    
    var block: ((VideoDetailsModel) -> Void)?
    
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - Action Methods -
    
    @IBAction func backTapHandler(button: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    
    //--------------------------------------------------------------------------------------
   
    //MARK: - View Life Cycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videosData = videos.videos
        
        tableView.registerCell(VideoListTVCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - Memory Management -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //--------------------------------------------------------------------------------------
}

    // MARK: - UITableViewDelegate

extension VideoSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        block?(videosData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 92.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "", handler: { (action, indexPath) in
            print("Delete tapped")
        })
        deleteAction.backgroundColor = view.backgroundColor
        return [deleteAction]
    }
}

    // MARK: - UITableViewDataSource

extension VideoSearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(VideoListTVCell.self)
        let videoDetails = videosData[indexPath.row]
        cell.titleLabel.text = videoDetails.videoName
        cell.subtitleLabel.text = videoDetails.category
        cell.checkIV.isHidden = !(videoDetails.watched ?? false) 
        //let duration = Int(Double(videoDetails!.videoDuration!) ?? 0.0)
        //cell.timeLabel.text = String(format: "%02d:%02d", duration / 60, duration % 60)
        let duration = Int(Double(videosData[indexPath.row].videoDuration!) ?? 0.0)
        cell.timeLabel.text = String(format: "%02d:%02d", duration / 60, duration % 60)
        return cell
    }
    
}

    // MARK: - UISearchBarDelegate

extension VideoSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        videosData = videos.videos.filter { ($0.videoName!.localizedCaseInsensitiveContains(searchBar.text!)) }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
