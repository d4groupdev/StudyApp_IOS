
import UIKit

class InsightsResultsVC: BaseVC {
    
    //MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var redoExamButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var backgroundIV: UIImageView!

    //--------------------------------------------------------------------------------------
    
    //MARK: - Class Variables -
    var guizId: Int = 0
    var popToRoot: Bool = false
    var data : QuizResultsDetailModel?
    //--------------------------------------------------------------------------------------
    
    var isNCLEX = false
    
    //MARK: - Custom Methods -
    func setupAppear() {
        tableView.tableHeaderView = getMainHeader()
        tableView.reloadData()
        if let data = self.data, let quizDate = data.quizDate {
            titleLabel.text = "Result - \(quizDate)"
        }
    }
    
    func getMainHeader() -> UIView? {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) ? "InsightsResultsTableHeaderViewiPad" : "InsightsResultsTableHeaderView"  , bundle: bundle)
        let insightsResultsTableHeaderView = nib.instantiate(withOwner: self, options: nil).first as? InsightsResultsTableHeaderView
        
               
        if let data = self.data {
            insightsResultsTableHeaderView?.config(data: InsightsResultsTableHeaderModel(yourScore: CGFloat(data.quizScore ?? 0),
                                                                                         score: CGFloat(data.quizAverage ?? 0)))
        }
        return insightsResultsTableHeaderView
    }
    
    func getResultHeader() -> InsightsResultTableVC {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) ? "InsightsResultTableVCiPad" : "InsightsResultTableVC") as? InsightsResultTableVC else {
            fatalError("\(InsightsTableVC.self) probably not registered")
        }
        
        if isNCLEX {
            cell.viewMain.backgroundColor = .white
                    cell.progressRing.backgroundColor = .white
                    cell.progressRing.fontColor = UIColor(named: "colorTextButton") ?? .gray
                }
        
        return cell
    }
    
    func getResultCategoryTopicCell() -> InsightsResultCategoryTopicTableVC {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) ? "InsightsResultCategoryTopicTableVCiPad" : "InsightsResultCategoryTopicTableVC") as? InsightsResultCategoryTopicTableVC else {
            fatalError("\(InsightsTableVC.self) probably not registered")
        }
        
        if isNCLEX {
                    cell.progressRing.backgroundColor = .white
                    cell.progressRing.fontColor = UIColor(named: "colorTextButton") ?? .gray
                }
        
        return cell
    }
    
    func getResultShowDetailCell() -> InsightsResultShowDetailTableVC {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) ? "InsightsResultShowDetailTableVCiPad" : "InsightsResultShowDetailTableVC") as? InsightsResultShowDetailTableVC else {
            fatalError("\(InsightsResultShowDetailTableVC.self) probably not registered")
        }
        return cell
    }
    
    func  quizData(_ quizId: String) {
        let request = HttpQuizQuestions(quizId: quizId)
        request.run(vc: self, completionHandler: { [weak self] (object: Any) -> Void in
            guard let self = self else { return }            
            
            if let model = object as? QuizQuestionsModel {
                if !model.status {
                    let alert = UIAlertController(title: "", message: model.msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ acttion: UIAlertAction) -> Void in }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let vc = Questions.VC(.QuestionsTest) as! QuestionsTestVC
                    vc.questionDataModel = model.questionDataModel
                    vc.quizId = quizId
                    vc.isNCLEX = self.isNCLEX
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else {
                
            }
        }, failed: {})
    }
    
    //-------------------------------------------------------------------------------------
    
    //MARK: - API Validation
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - API Methods -
    func getData() {
        let request = HttpQuizResults()
        request.quiz_id = self.guizId
        if isNCLEX {
            request.action = "mobile_get_quiz_results"
        }
        request.run(vc: self, completionHandler: { [weak self] (object: Any) -> Void in
            guard let self = self else { return }
            if let model = object as? QuizResultsModel {
                self.data = model.data
                self.setupAppear()
            }
            else {
                
            }
        }, failed: {})
    }
    //--------------------------------------------------------------------------------------
    
    //MARK: - Delegate Methods -
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - Action Methods -
    @IBAction func backTapHandler(button: UIButton) {
        if popToRoot {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func redoTapHandler(button: UIButton) {
        quizData(String(guizId))
    }
    
    @IBAction func shareTapHandler(button: UIButton) {
    }
    
    
    //--------------------------------------------------------------------------------------
   
    //MARK: - View Life Cycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
                       
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            tableView.register(UINib(nibName: "InsightsResultTableVCiPad", bundle: nil), forCellReuseIdentifier: "InsightsResultTableVCiPad")
            tableView.register(UINib(nibName: "InsightsResultCategoryTopicTableVCiPad", bundle: nil), forCellReuseIdentifier: "InsightsResultCategoryTopicTableVCiPad")
            tableView.register(UINib(nibName: "InsightsResultShowDetailTableVCiPad", bundle: nil), forCellReuseIdentifier: "InsightsResultShowDetailTableVCiPad")
        } else {
            tableView.registerCell(InsightsResultTableVC.self)
            tableView.registerCell(InsightsResultCategoryTopicTableVC.self)
            tableView.registerCell(InsightsResultShowDetailTableVC.self)
        }


        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabBar()
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
       
    //--------------------------------------------------------------------------------------

    // MARK: - UITableViewDelegate

extension InsightsResultsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = self.data, data.quizResults.count > 0 {
            data.quizResults[indexPath.section].showTopics = !data.quizResults[indexPath.section].showTopics
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = getResultHeader()
        tableView.separatorColor = .clear
        if let data = self.data {
            let quizResult = data.quizResults[section]
            let average = quizResult.categoryScore > quizResult.categoryGlobalScore
            cell.setProgressValue(data:  quizResult, average: average)
            return cell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 156
    }
}

    // MARK: - UITableViewDataSource

extension InsightsResultsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data?.quizResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.data {
            let isCategoriesShow = data.quizResults[section].showTopics
            return isCategoriesShow ? data.quizResults[section].categoryTopics.count + 1 : 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let data = self.data, data.quizResults.count > 0 {
            let index = data.quizResults[indexPath.section].categoryTopics.count + 1
            let isCategoriesShow = data.quizResults[indexPath.section].showTopics
            
            if index == 1 {
                let cell = getResultShowDetailCell()
                cell.selectionStyle = .none
                cell.setValue(show: isCategoriesShow)
                return cell
            } else {
                if let categoryTopics = data.quizResults[indexPath.section].categoryTopics,
                   categoryTopics.count > indexPath.row,
                   isCategoriesShow {
                    let categoryTopicModel = categoryTopics[indexPath.row]
                    let cell = getResultCategoryTopicCell()
                    cell.selectionStyle = .none
                    cell.setProgressValue(data:  categoryTopicModel)
                    return cell
                } else {
                    let cell = getResultShowDetailCell()
                    cell.selectionStyle = .none
                    cell.setValue(show: isCategoriesShow)
                    return cell
                }
                
            }
        }

        return UITableViewCell()
    }
    
}
