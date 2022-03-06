//
//  AppComponent.swift
//  PictureDiary
//
//  Created by byunghak on 2022/03/04.
//

import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
