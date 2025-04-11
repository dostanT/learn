//
//  DownloadingImagesViewModel.swift
//  learn
//
//  Created by Dostan Turlybek on 11.04.2025.
//
import SwiftUI
import Combine

class DownloadingImagesViewModel: ObservableObject{
    
    @Published var dataArray: [PhotoModel] = []
    let dataService = PhotoModelDataService.instance
    
    var cancellables: Set<AnyCancellable> = []
    
    init(){
        
    }
    
    //тут подписываемся на photoModels в PhotoModelDataService
    func addSubscribers(){
        dataService.$photoModels
            .sink { [weak self] returnedPhotoModels in
            self?.dataArray = returnedPhotoModels
            }
            .store(in: &cancellables)
    }
    23:20 video
}

