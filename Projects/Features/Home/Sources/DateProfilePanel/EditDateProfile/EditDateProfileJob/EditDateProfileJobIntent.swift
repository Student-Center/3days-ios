//
//  EditDateProfileJobIntent.swift
//  Home
//
//  Created by 김지수 on 11/25/24.
//  Copyright © 2024 com.weave. All rights reserved.
//

import Foundation
import CommonKit
import CoreKit
import DesignCore
import Model

//MARK: - Intent
class EditDateProfileJobIntent {
    private weak var model: EditDateProfileJobModelActionable?
    private let input: DataModel

    // MARK: Life cycle
    init(
        model: EditDateProfileJobModelActionable,
        input: DataModel
    ) {
        self.input = input
        self.model = model
        model.setUserInfo(input.userInfo)
        let selectedAllJobs = input.userInfo.dreamPartner
            .jobOccupations
            .compactMap { JobOccupation(rawValue: $0) }
        model.setSelectedJobs(selectedAllJobs)
    }
}

//MARK: - Intentable
extension EditDateProfileJobIntent {
    protocol Intentable {
        // content
        func onTapJobOccupation(
            selectedAllJobs: [JobOccupation],
            selectedJob: JobOccupation
        )
        func onTapNextButton(state: EditDateProfileJobModel.Stateful)
        
        // default
        func onAppear()
        func task() async
    }
    
    struct DataModel {
        let userInfo: UserInfo
    }
}

//MARK: - Intentable
extension EditDateProfileJobIntent: EditDateProfileJobIntent.Intentable {
    // default
    func onAppear() {}
    
    func task() async {}
    
    // content
    func onTapJobOccupation(
        selectedAllJobs: [JobOccupation],
        selectedJob: JobOccupation
    ) {
        var result = selectedAllJobs
        if let index = result.firstIndex(where: { $0 == selectedJob }) {
            result.remove(at: index)
        } else {
            result.append(selectedJob)
        }
        model?.setSelectedJobs(result)
    }
    
    func onTapNextButton(state: EditDateProfileJobModel.Stateful) {
        
    }
}
