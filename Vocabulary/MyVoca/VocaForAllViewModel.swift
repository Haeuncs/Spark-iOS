//
//  VocaForAllViewModel.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/28.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PoingVocaSubsystem

enum VocaForAllOrderType: Int, CaseIterable {
    case recent
    case popular
    case sharedMyVoca

    var description: String {
        switch self {
        case .popular:
            return "인기순"
        case .recent:
            return "최신순"
        case .sharedMyVoca:
            return "공유중"
        }
    }
}

protocol VocaForAllViewModelInput {
    var orderType: BehaviorRelay<VocaForAllOrderType> { get }
    func deleteFolder(id: Int, successHandler: @escaping (() -> Void))
}

protocol VocaForAllViewModelOutput {
    var vocaForAllList: BehaviorRelay<[EveryVocaContent]> { get }
    var myFolderList: BehaviorRelay<[FolderResponse]> { get }
}

protocol VocaForAllViewModelType {
    var inputs: VocaForAllViewModelInput { get }
    var outputs: VocaForAllViewModelOutput { get }
}

class VocaForAllViewModel: VocaForAllViewModelType, VocaForAllViewModelInput, VocaForAllViewModelOutput {
    
    var inputs: VocaForAllViewModelInput { return self }
    var outputs: VocaForAllViewModelOutput { return self }

    // Input
    var orderType: BehaviorRelay<VocaForAllOrderType>
    // Output
    var vocaForAllList: BehaviorRelay<[EveryVocaContent]>
    var myFolderList: BehaviorRelay<[FolderResponse]>

    var disposeBag = DisposeBag()
    
    init() {
        orderType = BehaviorRelay<VocaForAllOrderType>(value: .recent)
        vocaForAllList = BehaviorRelay<[EveryVocaContent]>(value: [])
        myFolderList = BehaviorRelay<[FolderResponse]>(value: [])

        orderType.bind{ [weak self] (type) in
            guard let self = self else { return }
            switch type {
            // TODO: Apply sort type
            case .popular, .recent:
                self.fetchVocaForAllData()
            case .sharedMyVoca:
                self.fetchMyFolder()
            }
        }.disposed(by: disposeBag)

    }

    private func fetchVocaForAllData() {
        EveryVocabularyController.shared.getEveryVocabularies()
            .bind { [weak self] (response) in
                guard let self = self else { return }
                self.vocaForAllList.accept(response.content)
            }
            .disposed(by: disposeBag)
    }

    private func fetchMyFolder() {
        FolderController.shared.getMyFolder()
            .bind { [weak self] (response) in
                guard let self = self else { return }
                self.myFolderList.accept(response)
            }
            .disposed(by: disposeBag)
    }

    public func deleteFolder(id: Int, successHandler: @escaping (() -> Void)) {
        deleteFolderRequest(id: id) {

            let folders = self.myFolderList.value.filter { (response) -> Bool in
                response.id != id
            }

            self.myFolderList.accept(folders)

//            VocaManager.shared.delete(group: <#T##Group#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        }
    }


    func deleteFolderRequest(id: Int, successHandler: @escaping (() -> Void)) {
        FolderController.shared.deleteFolder(folderId: [id])
            .subscribe { (response) in
                print(response)
                if response.element?.statusCode == 200 {
                    // success
                    successHandler()
                }
                else {
                    // error
                }
            }
            .disposed(by: disposeBag)
    }
}
