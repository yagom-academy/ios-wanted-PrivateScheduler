//
//  LoginFlowCoordinator.swift
//  PersonalScheduler
//
//  Created by 이원빈 on 2023/01/09.
//

import UIKit
import FirebaseAuth

protocol LoginFlowCoordinatorDependencies: AnyObject {
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
    func makeSigninViewController(actions: SigninViewModelActions) -> SigninViewController
}

final class LoginFlowCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    private var dependencies: LoginFlowCoordinatorDependencies
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController,
         dependencies: LoginFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(
            loginButtonTapped: loginButtonTapped,
            signinButtonTapped: signinButtonTapped,
            kakaoLogoButtonTapped: kakaoLogoButtonTapped,
            facebookLogoButtonTapped: facebookLogoButtonTapped,
            appleLogoButtonTapped: appleLogoButtonTapped
        )
        let loginVC = dependencies.makeLoginViewController(actions: actions)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    private func loginButtonTapped(_ loginInfo: LoginInfo) {
        Auth.auth().signIn(withEmail: loginInfo.id, password: loginInfo.password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print(String(describing: error))
                DefaultAlertBuilder(title: "알람", message: "사용자를 찾을 수 없습니다." ,preferredStyle: .alert)
                    .setButton(name: "예", style: .default)
                    .showAlert(on: self.navigationController.viewControllers.last!)
            } else {
                let newDependency = ScheduleSceneDIContainer()
                let flow = newDependency.makeMainFlowCoordinator(
                    navigationController: self.navigationController
                )
                flow.start()
            }
        }
    }
    
    private func signinButtonTapped() {
        print("회원가입 버튼 탭 !")
        let actions = SigninViewModelActions(registerButtonTapped: registerButtonTapped)
        let signinVC = dependencies.makeSigninViewController(actions: actions)
        navigationController.pushViewController(signinVC, animated: true)
    }
    
    private func kakaoLogoButtonTapped() {
        print("kakao 버튼 탭 !")
    }
    
    private func facebookLogoButtonTapped() {
        print("facebook 버튼 탭 !")
    }
    
    private func appleLogoButtonTapped() {
        print("apple 버튼 탭 !")
    }
    
    private func registerButtonTapped(_ loginInfo: LoginInfo) {
        print("등록 버튼 탭 !")
        // 아이디, 비밀번호 Firebase에 등록
        Auth.auth().createUser(withEmail: loginInfo.id, password: loginInfo.password) { authResult, error in
            guard error == nil else {
                print(String(describing: error))
                return
            }
            guard let authResult = authResult else { return }
            DefaultAlertBuilder(
                title: "알람",
                message: "\(authResult.user.email ?? "e-mail") 등록 완료 !",
                preferredStyle: .alert
            ).setButton(name: "확인", style: .default) {
                self.navigationController.popViewController(animated: true)
            }.showAlert(on: self.navigationController.viewControllers.last!)
        }
    }
}
