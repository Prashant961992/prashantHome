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
        productCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")

        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
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
        
        viewModel.model.productData.asObservable()
            .bind{ value in
                self.productCollectionView.reloadData()
            }.disposed(by: disposeBag)
        
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight {
            if self.viewModel.isLoading.value == false {
                if self.viewModel.model.productData.value.data?.pagination?.page != self.viewModel.model.productData.value.data?.pagination?.totalPage {
                    viewModel.getProductData()
                }
            }
        }
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
            return self.viewModel.marketListData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
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
            let data = self.viewModel.marketListData[indexPath.row]
            let url = URL(string: data.imgURL ?? "")
            cell.labelNameProduct.text = data.name ?? ""
            cell.labelPrice.text = "UZS" + String(data.localPrice ?? 0)
            cell.labelCrossPrice.text = "UZS" + String(data.localCrossedPrice ?? 0)
            
            cell.labelRate.text = String(format: "Rank: %@", "\(data.rank ?? 0)")
            cell.imageProduct.kf.setImage(with: url,
            placeholder: UIImage(named:"noData"),
            options: [.transition(ImageTransition.fade(1))],
            progressBlock: { receivedSize, totalSize in },
            completionHandler:  nil)
           
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
            
            if kind == UICollectionView.elementKindSectionHeader {
                // Create a view for the header view
                let headerContentView = UIView(frame: CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height))
                headerContentView.backgroundColor = UIColor.clear
                let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: headerContentView.frame.size.width, height: headerContentView.frame.size.height))
                headerLabel.text = self.viewModel.model.bannerData.value.data?.recommended?.name ?? ""
                headerLabel.textColor = UIColor.black
                headerLabel.textAlignment = .center
                headerContentView.addSubview(headerLabel)
                headerView.addSubview(headerContentView)
            }
            
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: productCollectionView.bounds.width, height: 50.0)
        } else {
            return CGSize(width: productCollectionView.bounds.width, height: 0)
        }
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: productCollectionView.bounds.width, height: 200)
        } else {
            return CGSize(width: (productCollectionView.bounds.width / 2) , height: 315)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
