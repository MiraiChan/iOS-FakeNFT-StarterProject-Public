//
//  CatalogСollectionPresenter.swift
//  FakeNFT
//
//  Created by Almira Khafizova on 23.01.24.
//

import Foundation

// MARK: - Protocol

protocol CatalogСollectionPresenterProtocol: AnyObject {
    var viewController: CatalogСollectionViewControllerProtocol? { get set }
    var userURL: String? { get }
    var nftArray: [Nft] { get }
    func loadNFTs()
    func getUserProfile() -> ProfileModel?
    func loadAuthorWebsite(_ url: URL?)
    func loadUserProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func isAlreadyLiked(nftId: String) -> Bool
    func presentCollectionViewData()
    func toggleLikeStatus(model: Nft, _ setIsLiked: @escaping (Bool) -> Void)
    func toggleCartStatus(model: Nft)
}

// MARK: - Final Class

final class CatalogСollectionPresenter: CatalogСollectionPresenterProtocol {
    func loadAuthorWebsite(_ url: URL?) {
        //?
    }
    
    func getUserProfile() -> ProfileModel? {
        return self.userProfile
    }
    
    weak var viewController: CatalogСollectionViewControllerProtocol?
    private var dataProvider: CollectionDataProvider
    private var userProfile: ProfileModel?
    
    let cartController: CartControllerProtocol
    let nftModel: NFTCollection
    var userURL: String?
    var nftArray: [Nft] = []
    
    init(nftModel: NFTCollection, dataProvider: CollectionDataProvider, cartController: CartControllerProtocol) {
        self.nftModel = nftModel
        self.dataProvider = dataProvider
        self.cartController = cartController
    }
    
    func presentCollectionViewData() {
        let viewData = CatalogCollectionViewData(
            coverImageURL: nftModel.cover,
            title: nftModel.name,
            description: nftModel.description,
            authorName: nftModel.author)
        viewController?.renderViewData(viewData: viewData)
    }
    
    func setUserProfile(_ profile: ProfileModel) {
        self.userProfile = profile
    }
    
    func loadUserProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        dataProvider.getUserProfile { [weak self] result in
            switch result {
            case .success(let profileModel):
                self?.setUserProfile(profileModel)
                completion(.success(profileModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNFTs() {
        var nftArray: [Nft] = []
        let group = DispatchGroup()
        
        for nft in nftModel.nfts {
            group.enter()
            dataProvider.loadNFTsBy(id: nft) { result in
                switch result {
                case .success(let data):
                    nftArray.append(data)
                case .failure(let error):
                    print("loadNFTsError: ", error)
                }
                group.leave()
            }
        }
        group.wait()
        group.notify(queue: .main) {
            self.nftArray = nftArray
            self.viewController?.reloadCollectionView()
        }
        
        self.loadUserProfile() { updateResult in
            switch updateResult {
            case .success(let result):
                self.nftArray = self.nftArray.map {
                    var nft = $0
                    let newLiked = result.likes?.contains($0.id) ?? false
                    return $0.update(newLiked: newLiked)
                }
                print("nftArray: \(self.nftArray)")
            case .failure(let error): break
                // TODO: Handle the error if needed
            }
        }
    }
    
    func isAlreadyLiked(nftId: String) -> Bool {
        return self.userProfile?.likes?.contains { $0 == nftId } == true
    }
    
    func toggleLikeStatus(model: Nft, _ setIsLiked: @escaping (Bool) -> Void) {
        guard let profileModel = self.userProfile else {
            return
        }
        let isAlreadyLiked = profileModel.likes?.contains { $0 == model.id } == true
        
        let updatedLikes = isAlreadyLiked
        ? profileModel.likes?.filter { $0 != model.id }
        : (profileModel.likes ?? []) + [model.id]
        
        setIsLiked(!isAlreadyLiked)
        
        let updatedProfileModel = profileModel.update(newLikes: updatedLikes)
        
        dataProvider.updateUserProfile(with: updatedProfileModel) { updateResult in
            switch updateResult {
            case .success(let result):
                // TODO: Profile updated successfully and (save likes?)
                self.setUserProfile(result)
                
                self.nftArray = self.nftArray.map {
                    var nft = $0
                    if nft.id == model.id {
                        let newLiked = !isAlreadyLiked
                        nft = nft.update(newLiked: newLiked)
                    }
                    return nft
                }
                self.viewController?.reloadCollectionView()
            case .failure(let error): break
                // TODO: Handle the error if needed
            }
        }
    }
    
    func toggleCartStatus(model: Nft) {
        let itemInCart = cartController.cart.contains(where: { $0.id == model.id })
        if itemInCart {
            cartController.removeFromCart(model.id) {
                // TODO: Handle item removal from cart
            }
        } else {
            cartController.addToCart(model) {
                // TODO: Handle item addition to cart
            }
        }
    }
}
