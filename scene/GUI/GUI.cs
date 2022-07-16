using Godot;
using System;

public class GUI : HBoxContainer
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";
    enum Modes
    {
        Simple,
        Empty,
        Partial
    }

    public var heartFull = ResourcePreloader("res")
        
        
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
