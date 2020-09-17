//
//  FolderController.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/09/17.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import RxSwift
import Moya

public class FolderController {
    public static let shared = FolderController()
    private let serviceManager = FolderServiceManager()

    public func getMyFolder() -> Observable<[FolderResponse]> {
        return serviceManager.provider.rx
            .request(FolderService.getMyFolder)
            .map([FolderResponse].self)
            .asObservable()
    }

    public func addFolder(name: String, shareable: Bool = true) -> Observable<Response> {
        return serviceManager.provider.rx
            .request(FolderService.addFolder(name: name, shareable: shareable))
            .asObservable()
    }

    public func deleteFolder(folderId: [Int]) -> Observable<Response> {
        return serviceManager.provider.rx
            .request(FolderService.deleteFolder(folderId: folderId))
            .asObservable()
    }

    public func editFolder(folderId: Int, name: String, shareable: Bool = true) -> Observable<Any> {
        return serviceManager.provider.rx
            .request(FolderService.editFolder(folderId: folderId, name: name, shareable: shareable))
            .mapJSON()
            .asObservable()
    }
}
