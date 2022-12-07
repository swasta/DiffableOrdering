//
//  Created by Nikita Borodulin on 06.12.2022.
//

import UIKit

struct Recipe: Identifiable {
    let id: Int
    let title: String
    let isFavorite: Bool
}

class ViewController: UICollectionViewController {

    enum SectionID: Int {
        case favorite
        case standard
    }

    struct Section {
        let recipes: [Recipe]
    }

    private var recipeListDataSource: UICollectionViewDiffableDataSource<SectionID, Recipe.ID>!


    private var recipes: [Section] = [
        .init(recipes: [
            .init(id: 1, title: "1 Recipe", isFavorite: true),
            .init(id: 2, title: "2 Recipe", isFavorite: true),
            .init(id: 3, title: "3 Recipe", isFavorite: true)
        ]),
        .init(recipes: [
            .init(id: 4, title: "4 Recipe", isFavorite: false),
            .init(id: 5, title: "5 Recipe", isFavorite: false),
            .init(id: 6, title: "6 Recipe", isFavorite: false)
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "RecipeCell")

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.layout(environment: layoutEnvironment)
        }

        collectionView.collectionViewLayout = layout

        recipeListDataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
                let recipe = self.recipes[indexPath.section].recipes[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
                cell.configure(recipe: recipe)
                return cell
        })

        var snapshot = NSDiffableDataSourceSnapshot<SectionID, Recipe.ID>()
        snapshot.appendSections([.favorite, .standard])
        snapshot.appendItems([1, 2, 3], toSection: .favorite)
        snapshot.appendItems([4, 5, 6], toSection: .standard)
        recipeListDataSource.applySnapshotUsingReloadData(snapshot)
    }

    @IBAction func barButtonItemTyped(_ sender: Any) {

        self.recipes = [
            .init(recipes: [
                .init(id: 4, title: "4 Recipe", isFavorite: false),
                .init(id: 5, title: "5 Recipe", isFavorite: false),
                .init(id: 6, title: "6 Recipe", isFavorite: false)
            ]),
            .init(recipes: [
                .init(id: 1, title: "1 Recipe", isFavorite: true),
                .init(id: 2, title: "2 Recipe", isFavorite: true),
                .init(id: 3, title: "3 Recipe", isFavorite: true)
            ])
        ]

        var snapshot = NSDiffableDataSourceSnapshot<SectionID, Recipe.ID>()
        snapshot.appendSections([.standard, .favorite])
        snapshot.appendItems([4, 5, 6], toSection: .standard)
        snapshot.appendItems([1, 2, 3], toSection: .favorite)


        // Option 1: buggy

        snapshot.reconfigureItems([1, 2, 3])
        recipeListDataSource.apply(snapshot)

        // Option 2: seems to work

//        recipeListDataSource.apply(snapshot) {
//            snapshot.reconfigureItems([1, 2, 3])
//            self.recipeListDataSource.apply(snapshot)
//        }
    }

    private func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))

        let section = NSCollectionLayoutSection(group: .horizontal(layoutSize: groupSize, subitems: [item]))
        section.interGroupSpacing = 8
        section.contentInsets = .init(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        return section
    }
}
