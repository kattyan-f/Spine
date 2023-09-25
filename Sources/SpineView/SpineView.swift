//
//  SpineView.swift
//
//  Created by 梶 剛志 on 2023/09/15.
//

import SwiftUI
import SpriteKit

struct SpineView: View {
    var spineView: SpineViewRepresentable
    
    let jsonFile: String
    let folderName: String
    let skinName: String
    
    init(jsonFile: String, folderName: String, skinName: String = "default") {
        self.jsonFile = jsonFile
        self.folderName = folderName
        self.skinName = skinName
        
        spineView = SpineViewRepresentable(jsonFile: jsonFile, folderName: folderName, skinName: skinName)
    }
    
    var body: some View {
        spineView
    }
    
    func actionSequence(actions: [SKAction]) {
        spineView.actionSequence(actions: actions)
    }
    
    func moveAction(point: CGPoint, duration: Double) {
        spineView.moveAction(point: point, duration: duration)
    }
    
    func rotateAction(toAngle: CGFloat, duration: Double) {
        spineView.rotateAction(toAngle: toAngle, duration: duration)
    }
    
    func playAnimation(animation: String) {
        spineView.playAnimation(animation: animation)
    }
}

struct SpineViewRepresentable: UIViewRepresentable {
    var character:Skeleton?
    
    let jsonFile: String
    let folderName: String
    let skinName: String
    
    init(jsonFile: String, folderName: String, skinName: String) {
        self.jsonFile = jsonFile
        self.folderName = folderName
        self.skinName = skinName
        
        do {
            self.character = try Skeleton(json: jsonFile, folder: folderName, skin: skinName)
        }catch {
            self.character = nil
            print(error)
        }
    }
    
    class Coordinator: NSObject {
        var scene: SKScene?
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> SKView {
        //SkView作成
        let skView = SKView()
        //FPSの表示
        //skView.showsFPS = true
        //ノード数表示
        //skView.showsNodeCount = true
        //シーン作成
        let scene = SKScene()
        //背景透過
        scene.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        //spriteの中心を設定する
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = UIScreen.main.nativeBounds.size
        
        
        do {
            character!.name = folderName
            character!.position = CGPoint(x: 0, y: 0)
            scene.addChild(character!)
            
            let animation = try character!.action(animation: "idle")
            character!.run(.repeatForever(animation))

        } catch {
            print(error)
        }
        
        scene.scaleMode = .aspectFill
        //シーンをこのviewの内容に設定
        context.coordinator.scene = scene

        return skView
    }
    
    /*
     *  複数アクション登録
     */
    func actionSequence(actions: [SKAction]) {
        if character != nil{
            let actions = SKAction.sequence(actions)
            character!.run(actions)
        }
    }
    
    /*
     *  座標移動アクション登録
     */
    func moveAction(point: CGPoint, duration: Double) {
        if character != nil{
            let action = SKAction.move(to: point, duration: duration)
            character!.run(action)
        }
    }
    
    /*
     *  回転アクション登録
     */
    func rotateAction(toAngle: CGFloat, duration: Double) {
        if character != nil{
            let action = SKAction.rotate(toAngle: toAngle, duration: duration)
            character!.run(action)
        }
    }
    
    /*
     *  アニメーション再生
     */
    func playAnimation(animation: String) {
        if character != nil{
            do {
                let animation = try character!.action(animation: animation)
                character!.run(.repeatForever(animation))
            } catch {
                print(error)
            }
        }
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.presentScene(context.coordinator.scene)
    }
}


struct SpineView_Previews: PreviewProvider {
    static var previews: some View {
        SpineViewRepresentable(jsonFile: "spineboy-ess", folderName: "Boys", skinName: "default")
    }
}
