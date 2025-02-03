import UIKit

// MARK: - View Controller
class ProfileViewController: UIViewController {
    var interactor: ProfileInteractorProtocol?
    var coordinator: ProfileCoordinatorProtocol?
    
    private lazy var navigationView: LoudNavigationView = {
        let navigationView = LoudNavigationView.instantiate(viewModel: LoudItemViewModel(title: "Meu Perfil")) {}
        return navigationView
    }()
    
    private let nameLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let separatorView1 = UIView()
    private let myLoudIdLabel = UILabel()
    
    private lazy var myDataItem: LoudItemView = {
        return LoudItemView.instantiate(viewModel: LoudItemViewModel(title: "Meus Dados")) { [weak self] _ in self?.coordinator?.openMyData() }
    }()
    
    private lazy var privacyItem: LoudItemView = {
        return LoudItemView.instantiate(viewModel: LoudItemViewModel(title: "Privacidade")) { [weak self] _ in self?.coordinator?.openPrivacy() }
    }()
    
    private lazy var quickAccessItem: LoudItemView = {
        return LoudItemView.instantiate(viewModel: LoudItemViewModel(title: "Acesso Rápido")) { _ in }
    }()
    
    private let separatorView2 = UIView()
    
    private lazy var bankAccountItem: LoudItemView = {
        return LoudItemView.instantiate(viewModel: LoudItemViewModel(title: "Conta Banco")) { [weak self] _ in self?.coordinator?.openBankAccount() }
    }()
    
    private let separatorView3 = UIView()
    
    private lazy var rateAppItem: LoudItemView = {
        return LoudItemView.instantiate(viewModel: LoudItemViewModel(title: "Avalie o App")) { [weak self] _ in self?.coordinator?.openRateApp() }
    }()
    
    private lazy var logoutItem: LoudItemView = {
        return LoudItemView.instantiate(viewModel: LoudItemViewModel(title: "Sair do App")) { [weak self] _ in self?.coordinator?.openLogoutDialog() }
    }()
    
    private let separatorView4 = UIView()
    private let socialLabel = UILabel()
    private let socialStackView = UIStackView()
    private let appVersionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        interactor?.fetchProfile()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        nameLabel.text = "Meu Perfil"
        myLoudIdLabel.text = "Meu Loud ID"
        socialLabel.text = "Nossas Redes"
        appVersionLabel.text = "Versão do App"
        
        [separatorView1, separatorView2, separatorView3, separatorView4].forEach {
            $0.backgroundColor = .black
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 4).isActive = true
        }
        
        socialStackView.axis = .horizontal
        socialStackView.distribution = .fillEqually
        socialStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for imageName in ["A.jpg", "B.jpg", "C.jpg", "D.jpg", "E.jpg", "F.jpg"] {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: imageName), for: .normal)
            button.addTarget(self, action: #selector(socialButtonTapped(_:)), for: .touchUpInside)
            socialStackView.addArrangedSubview(button)
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let stackView = UIStackView(arrangedSubviews: [
            separatorView1, myLoudIdLabel,
            myDataItem, privacyItem, quickAccessItem, separatorView2,
            bankAccountItem, separatorView3, rateAppItem, logoutItem, separatorView4,
            socialLabel, socialStackView, appVersionLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func displayProfileData(viewModel: ProfileViewModel) {
        nameLabel.text = viewModel.name ?? "Meu Perfil"
        appVersionLabel.text = "Versão do App " + viewModel.appVersion
    }
    
    @objc private func socialButtonTapped(_ sender: UIButton) {
        // Ação de cada botão de rede social será implementada depois
    }
}

// MARK: - Interactor
protocol ProfileInteractorProtocol {
    func fetchProfile()
}

class ProfileInteractor: ProfileInteractorProtocol {
    var presenter: ProfilePresenterProtocol?
    
    func fetchProfile() {
        let profile = ProfileModel(name: "John Doe", appVersion: "1.0.0")
        presenter?.presentProfileData(profile: profile)
    }
}

// MARK: - Presenter
protocol ProfilePresenterProtocol {
    func presentProfileData(profile: ProfileModel)
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var viewController: ProfileViewController?
    
    func presentProfileData(profile: ProfileModel) {
        let viewModel = ProfileViewModel(name: profile.name, appVersion: profile.appVersion)
        viewController?.displayProfileData(viewModel: viewModel)
    }
}

// MARK: - Coordinator
protocol ProfileCoordinatorProtocol {
    func openMyData()
    func openPrivacy()
    func openBankAccount()
    func openRateApp()
    func openLogoutDialog()
}

class ProfileCoordinator: ProfileCoordinatorProtocol {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func openMyData() {
        // Implementação para navegar para a tela "Meus Dados"
    }

    func openPrivacy() {
        // Implementação para navegar para a tela "Privacidade"
    }

    func openBankAccount() {
        // Implementação para navegar para a tela "Conta Banco"
    }

    func openRateApp() {
        // Implementação para navegar para a tela "Avalie o App"
    }

    func openLogoutDialog() {
        // Implementação para exibir o diálogo de logout
    }
}

// MARK: - Factory
class ProfileFactory {
    static func createModule(coordinator: ProfileCoordinatorProtocol) -> ProfileViewController {
        let viewController = ProfileViewController()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        
        viewController.interactor = interactor
        viewController.coordinator = coordinator
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}

// MARK: - Models
struct ProfileModel {
    var name: String?
    var appVersion: String
}

struct ProfileViewModel {
    var name: String?
    var appVersion: String
}
