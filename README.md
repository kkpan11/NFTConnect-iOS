# NFTConnect-iOS
NFTConnect-iOS is written in Swift that utilizes data from [Alchemy](https://www.alchemy.com/) & [OpenSea Testnets](https://testnets.opensea.io/).

## Setup

## Architecture

### MVVM-C
```mermaid
graph TD
    subgraph Coordinator;
        AppDelegate --> NFTListCoordinator;
        NFTListCoordinator --> NFTDetailCoordinator;
        NFTDetailCoordinator --> OpenWeb;
    end;
    subgraph List Scene;
        NFTListCollectionViewProvider -- View State Closure --> NFTListViewController;
        NFTListViewModel -- ViewModel State Closure --> NFTListViewController;
    end;
    subgraph Detail Scene;
        NFTDetailViewModel -- ViewModel State Closure --> NFTDetailViewController;
        NFTDetailViewProvider -- View State Closure --> NFTDetailViewController;
    end;
```

## Design patterns

## Contribute

### Pull request

Pull request are more than welcome! If you do submit one, please make sure to use a descriptive title and description.
