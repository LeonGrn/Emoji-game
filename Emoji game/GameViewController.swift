//
//  ViewController.swift
//  Emoji game
//
//  Created by Leon Grinshpun on 21/05/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var game_timer: UILabel!
    @IBOutlet weak var game_moves_counter: UILabel!
    @IBOutlet var game_card_btn: [UIButton]!
    private let game_images = [#imageLiteral(resourceName: "suspicious"),#imageLiteral(resourceName: "nerd"),#imageLiteral(resourceName: "kissing"),#imageLiteral(resourceName: "quiet"),#imageLiteral(resourceName: "ninja"),#imageLiteral(resourceName: "surprised"),#imageLiteral(resourceName: "smart"),#imageLiteral(resourceName: "smiling")]
    private let backCard = #imageLiteral(resourceName: "background")
    private var board:[UIImage] = []
    private var game_first_clicked_card: UIButton? = nil
    private var clickCounter = 0
    private var successCounter = 0
    private var timer = Timer()
    private var checkWinPairs = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initGame()

    }
    
    func initGame(){
        print("\(game_card_btn.count)")
        for card in game_card_btn{
            card.setImage(backCard, for:.normal)
            card.isEnabled = true
        }
        shuffle()
        successCounter = 0
        setTimer(on: true)
        checkWinPairs = 0
        successCounter = 0
        game_moves_counter.text = "\(successCounter)"
    }
    
    func shuffle(){
        for image in game_images {
            self.board.append(image)
            self.board.append(image)
        }
        self.board.shuffle()
    }
    
    func addMove(){
        successCounter += 1
        game_moves_counter.text = "\(successCounter)"
    }
    
    func openCard(card: UIButton){
        UIView.transition(with: card, duration: 0.4, options: .transitionFlipFromLeft,
                          animations: nil, completion: nil)
    }
    
    func closeCard(card: UIButton){
        card.setImage(self.backCard, for: .normal)
        UIView.transition(with: card, duration: 0.4, options: .transitionFlipFromRight,
                          animations: nil, completion: nil)
    }
    
    func setTimer(on: Bool){
        if(on) {//run timer each second
            var duration = 0
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            duration += 1
            let mins = duration / 60 % 60
            let secs = duration % 60
            self.game_timer.text = ((mins<10) ? "0" : "") + String(mins) + ":" + ((duration<10) ? "0" : "") + String(secs) + " S"
            }
        }
        else {
            self.game_timer.text = "00:00 S"
            timer.invalidate()//pause
        }
    }
    
    func gameOver(card: UIButton){
        if(checkWinPairs == 8)
        {
            setTimer(on: false)
            createAlertForUserName()
        }
    }
    
    func disableOrUnableGameBoard(on : Bool){
        
            for element in self.game_card_btn
            {
                    element.isUserInteractionEnabled = on
            }
    }
    
    func createAlertForUserName() {
        //get name from user throgh alertController
        let alert = UIAlertController(title: "Congratulation! ",
                                      message: " You won!",
                                      preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Play Again", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            print(alert.textFields![0].text!)
            self.initGame()

        })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Enter your name"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)
    }
    

    
    @IBAction func game_card_click(_ sender: UIButton)
    {
        
        if(clickCounter == 1)
        {
            if(game_first_clicked_card == sender)
            {
                return;
            }
            sender.setImage(board[sender.tag], for: .normal)
            openCard(card: sender)
            
            if(board[sender.tag] == board[game_first_clicked_card!.tag])
            {
                sender.isEnabled = false
                game_first_clicked_card?.isEnabled = false
                clickCounter = 0
                checkWinPairs += 1
            }
            else
            {

                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.closeCard(card: sender)
                    self.closeCard(card: self.game_first_clicked_card!)
                }
                clickCounter = 0
            }
            addMove()
            gameOver(card: sender)
        }
        else
        {
            sender.setImage(board[sender.tag], for: .normal)
            openCard(card: sender)
            clickCounter = 1
            game_first_clicked_card = sender
            
        }
    }
}

