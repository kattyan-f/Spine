//
//  SpineSampleUIViewController.swift
//
//  Created by 梶 剛志 on 2023/09/21.
//

import SwiftUI
import UIKit
import SpriteKit

class SpineSampleUIViewController: UIViewController {
    
    var scene: SpineSampleScene? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Spine表示用Scene作成 */
        scene = SpineSampleScene()
        
        //let skView = self.view as! SKView
        let skView = SKView()
        view = skView
        
        /* Set the scale mode to scale to fit the window */
        if scene != nil {
            scene!.scaleMode = .aspectFill
            scene!.size = UIScreen.main.nativeBounds.size
            scene!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            skView.presentScene(scene!)
        }
    }
    
    /*
     *  run SKAction
     *  SKAction一覧 - https://developer.apple.com/documentation/spritekit/skaction/action_initializers
     */
    func action(){
        if scene != nil {
            /* 実装例 */
            let action1 = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1.0)
            let action2 = SKAction.rotate(toAngle: 0, duration: 1.0)
            
            scene!.action(action1) /* SKAction再生 */
            /*scene!.actionGroup([action1,action2]) /* SKAction一括再生 */ */
            /*scene!.actionSequence([action1,action2]) /* SKAction順番再生 */ */
        }
    }
}

class SpineSampleScene: SKScene {
    
    var spineView: Skeleton? /* SKNode */
    
    override func didMove(to view: SKView) {
        
        /* 背景透過 */
        backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        /* 背景画像を追加する場合SKSpriteNodeを利用すれば画像を背景表示できるはず */
        
        /* 背景追加例 */
        /*
        /* 背景画像のノードを作成 */
        let backNode = SKSpriteNode(imageNamed: "file_name")
        /* 背景画像のサイズをシーンと同じにする*/
        backNode.size = self.frame.size
        /* 背景画像の位置をシーンの中央にする*/
        backNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
         */
        
        do {
            
            /*
             *  Spine生成
             *  json：プロジェクトに追加したJSONファイル名
             *  folder：Asset Catalogに追加したフォルダ名
             *  skin：folder階層内のsprite atlasのフォルダ名(spineデータのスキン名に合わせる)
             */
            spineView = try Skeleton(json: "spineboy-ess", folder: "Boys", skin: "default")
            spineView!.name = "Boys"
            spineView!.position = CGPoint(x: 0, y: 0)
            
            /* add spine view to scene */
            self.addChild(spineView!)
            
            actionAnimation(animation:"idle", loop: true)
            
        }catch {
            spineView = nil
            print(error)
        }
    }
    
    /*
     *  run SKAction
     */
    func action(_ action: SKAction) {
        if spineView != nil {
            /* SKAction再生 */
            spineView!.run(action)
        }
    }
    
    /*
     *  run SKActions group - 一括再生
     */
    func actionGroup(_ actions: [SKAction]) {
        if spineView != nil {
            /* SKAction作成 */
            let actions = SKAction.group(actions)
            /* SKAction再生 */
            spineView!.run(actions)
        }
    }
    
    /*
     *  run SKActions sequence - 順番再生
     */
    func actionSequence(_ actions: [SKAction]) {
        if spineView != nil {
            /* SKAction作成 */
            let actions = SKAction.sequence(actions)
            /* SKAction再生 */
            spineView!.run(actions)
        }
    }
    
    /*
     *  run Spine Animation
     */
    func actionAnimation(animation: String, loop: Bool = false) {
        if spineView != nil{
            do {
                /* SKAction作成 - アニメーションだけ作成方法が違う */
                let animation = try spineView!.action(animation: animation)
                /* SKAction再生 - アニメーションはループ再生させるかの分岐あり */
                if loop {
                    spineView!.run(.repeatForever(animation))
                } else {
                    spineView!.run(animation)
                }
            } catch {
                print(error)
            }
        }
    }
    
    /*
     *  タップイベント
     *  サンプルとしてタップした位置に移動するアクション
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if spineView != nil {
            /* SKAction作成 */
            let location = touches.first!.location(in: self)
            let action = SKAction.move(to: CGPoint(x: location.x, y: location.y), duration: 1.0)
            
            /* SKAction再生 */
            spineView!.run(action) {
                /* 再生完了後処理 */
                self.spineView!.removeAllActions()
                self.actionAnimation(animation: "idle", loop: true)
            }
            
            /* 移動に合わせてアニメーションも再生させてみる */
            actionAnimation(animation: "walk", loop: true)
        }
    }
}

/*
 * UIViewControllerをSwiftUIで表示するよう
 */
struct SpineSampleUIViewControllerRepresentable : UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> SpineSampleUIViewController {
        return SpineSampleUIViewController()
    }
    /* SwiftUI → UIkit */
    func updateUIViewController(_ uiViewController: SpineSampleUIViewController, context: Context) {
    }
    /* UIKit → SwiftUI */
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    class Coordinator {
    }
}
