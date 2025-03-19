using Godot;

public partial class Player : CharacterBody2D
{
	// Don't forget to rebuild the project so the editor knows about the new signal.
	[Signal]
	public delegate void HitEventHandler();

	[Export]
	private int _Speed { get; set; } = 400; // How fast the player will move (pixels/sec).

	[Export]
	private int jump_force = 300;

	[Export]
	public int _Gravity { get; set; } = 30;

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
		Vector2 velocity = Velocity;

		if (!IsOnFloor())
		{
			velocity.Y += _Gravity;
		}

		if (Input.IsActionJustPressed("jump"))
		{
			velocity.Y = -jump_force;
		}

		float horizontal_direction = Input.GetAxis("move_left", "move_right");

		velocity.X = _Speed * horizontal_direction;

		MoveAndSlide();

		GD.Print(Velocity);
    }
}
