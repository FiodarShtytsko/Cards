//
//  UICollectionView+.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import UIKit

protocol Identifiable {
    static var reuseIdentifier: String { get }
}

protocol NibLoadable {
    static var nibName: String { get }
}

extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadable, T: Identifiable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Identifiable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionViewCell: Identifiable { }

extension Identifiable where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: NibLoadable { }

extension NibLoadable where Self: UICollectionViewCell {
    static var nibName: String {
        return String(describing: self)
    }
}
