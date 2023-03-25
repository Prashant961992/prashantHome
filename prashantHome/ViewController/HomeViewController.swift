//
//  HomeViewController.swift
//  prashantHome
//
//  Created by Prashant Prajapati on 25/03/23.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
      
    @IBOutlet weak var productCollectionView: UICollectionView!
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        createCallbacks()
        viewModel.getBannerData()
    }
    
    
    func createCallbacks (){
        
        // success
        viewModel.isSuccess.asObservable()
            .bind{ value in
                if value{
//                    self.navigationController?.popViewController(animated: true)
                }
            }.disposed(by: disposeBag)
        
        viewModel.errorMsg.asObservable()
            .bind { errorMessage in
                if errorMessage.count > 0 {
                    self.showSnackbar(errorMessage)
                }
            }.disposed(by: disposeBag)
        
        viewModel.isLoading.asObservable()
            .bind { value in
                if value {
                    self.showHud()
                } else {
                    self.hideHud()
                }
        }.disposed(by: disposeBag)
        
        viewModel.model.bannerData.asObservable()
            .bind{ value in
                self.productCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
    }
}


extension HomeViewController : FSPagerViewDataSource {

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.viewModel.model.bannerData.value.data?.mainBanner?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let data = self.viewModel.model.bannerData.value.data?.mainBanner?[index]
        let url = URL(string: data?.imageURL ?? "")
        cell.imageView?.kf.setImage(with: url)
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description+index.description
        return cell
    }
}

extension HomeViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            cell.backgroundColor = UIColor.purple
            cell.adsBanner.isInfinite = true
            cell.adsBanner.interitemSpacing = 10
            cell.adsBanner.transformer = FSPagerViewTransformer(type: .crossFading)
            cell.adsBanner.numberOfItems = self.viewModel.model.bannerData.value.data?.mainBanner?.count ?? 0
            cell.adsBanner.dataSource = self
            cell.adsBanner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            cell.adsBanner.automaticSlidingInterval = 2.0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            if indexPath.row % 3 == 0 {
                cell.backgroundColor = UIColor.red
            } else {
                cell.backgroundColor = UIColor.blue
            }
            
            return cell
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: productCollectionView.bounds.width, height: 300)
        } else {
            return CGSize(width: productCollectionView.bounds.width / 2 , height: (productCollectionView.bounds.width / 2) + 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
