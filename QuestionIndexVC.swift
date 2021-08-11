
import UIKit

class QuestionIndexVC: BaseVC {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: UITableView!
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - Class Variables -
    
    var questionResult: [[String: Any]] = []
    var okImage = UIImage(named: "icon-performance-review-correct-answers")
    var failImage = UIImage(named: "icon-performance-review-incorrect-answers")
    var questionDataModel : QuestionDataModel!
    var mainVC: QuestionsTestVC!
    
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - Action Methods -
    
    @IBAction func closeTapHandler(button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //--------------------------------------------------------------------------------------
   
    //MARK: - View Life Cycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCell(QuizIndexTVCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

extension QuestionIndexVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcc = mainVC
        dismiss(animated: true) {
            vcc?.setQuestion(indexPath.row)
        }
    }
    
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
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

extension QuestionIndexVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionDataModel.examAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(QuizIndexTVCell.self)
        
        var text = questionDataModel.examAnswers[indexPath.row].questionDetail
        text = text?.replacingOccurrences(of: "<p>", with: "")
        text = text?.replacingOccurrences(of: "</p>", with: "")
        text = text?.replacingOccurrences(of: "\n", with: "")
        cell.titleLabel.text = "\(indexPath.row + 1). \(text ?? "")"
        
        cell.offImageView.isHidden = true
        if questionResult[indexPath.row]["answer"] as! String == "" {
            cell.mainImageView.image = nil
                       
            if questionResult[indexPath.row]["skip"] as! Bool {
                cell.mainImageView.contentMode = .center
                cell.mainImageView.image = UIImage(named: "check_")
            }
        }
        else {
            cell.mainImageView.contentMode = .scaleAspectFit
            if questionResult[indexPath.row]["correct"] as! Bool {
                cell.mainImageView.image = okImage
            }
            else {
                cell.mainImageView.image = failImage
            }
        }
        
        return cell
    }
    
}

