' ==========================================
' PONG in QBasic (Flicker-Free Version)
' Controls:
'   Player 1 (Left):  W / S
'   Player 2 (Right): UP ARROW / DOWN ARROW
'   Press ESC to quit
' ==========================================

Screen 13 ' 320x200 graphics mode
Cls

' Initialize Game Variables
ballX = 160: ballY = 100 ' Ball starting position
ballDX = 2: ballDY = 1 ' Ball velocity
p1Y = 80: p2Y = 80 ' Paddle Y positions
p1Score = 0: p2Score = 0 ' Scores
paddleHeight = 40
paddleWidth = 6
paddleSpeed = 3

' Store previous positions to erase only what moved (prevents flickering)
oldP1Y = p1Y
oldP2Y = p2Y
oldBallX = ballX
oldBallY = ballY

' Initial draw of static elements
Line (159, 0)-(159, 199), 8 ' Center line

Do
    ' Keep 60 FPS in QB64 (if running QB64, _DISPLAY handles double buffering)
    _Limit 60

    ' 1. STORE PREVIOUS POSITIONS BEFORE UPDATING
    oldP1Y = p1Y
    oldP2Y = p2Y
    oldBallX = ballX
    oldBallY = ballY

    ' 2. HANDLE INPUT
    k = Inp(&H60)

    ' W (17) / S (31)
    If Inp(&H60) = 17 Then p1Y = p1Y - paddleSpeed
    If Inp(&H60) = 31 Then p1Y = p1Y + paddleSpeed

    ' UP (72) / DOWN (80)
    If Inp(&H60) = 72 Then p2Y = p2Y - paddleSpeed
    If Inp(&H60) = 80 Then p2Y = p2Y + paddleSpeed

    ' ESC Key check
    If Inp(&H60) = 1 Then Exit Do
    k$ = InKey$
    If k$ = Chr$(27) Then Exit Do

    ' 3. BOUNDARY CHECKS FOR PADDLES
    If p1Y < 0 Then p1Y = 0
    If p1Y > 199 - paddleHeight Then p1Y = 199 - paddleHeight
    If p2Y < 0 Then p2Y = 0
    If p2Y > 199 - paddleHeight Then p2Y = 199 - paddleHeight

    ' 4. UPDATE BALL POSITION
    ballX = ballX + ballDX
    ballY = ballY + ballDY

    ' Top/Bottom wall bounce
    If ballY <= 0 Or ballY >= 195 Then
        ballDY = -ballDY
    End If

    ' 5. PADDLE COLLISIONS
    ' Left Paddle (Player 1)
    If ballX <= 16 And ballX >= 10 And ballDX < 0 Then
        If ballY >= p1Y And ballY <= p1Y + paddleHeight Then
            ballDX = -ballDX
            ballX = 17
        End If
    End If

    ' Right Paddle (Player 2)
    If ballX >= 304 And ballX <= 310 And ballDX > 0 Then
        If ballY >= p2Y And ballY <= p2Y + paddleHeight Then
            ballDX = -ballDX
            ballX = 303
        End If
    End If

    ' 6. SCORE CHECK
    If ballX < 0 Then
        p2Score = p2Score + 1
        ' Erase old ball before resetting
        Line (oldBallX, oldBallY)-(oldBallX + 3, oldBallY + 3), 0, BF
        ballX = 160: ballY = 100
        ballDX = 2
    End If

    If ballX > 319 Then
        p1Score = p1Score + 1
        ' Erase old ball before resetting
        Line (oldBallX, oldBallY)-(oldBallX + 3, oldBallY + 3), 0, BF
        ballX = 160: ballY = 100
        ballDX = -2
    End If

    ' 7. SMART REDRAW (Erase old, draw new - No full screen clear!)

    ' Erase old paddles and ball (draw black over old positions)
    Line (10, oldP1Y)-(10 + paddleWidth, oldP1Y + paddleHeight), 0, BF
    Line (304, oldP2Y)-(304 + paddleWidth, oldP2Y + paddleHeight), 0, BF
    Line (oldBallX, oldBallY)-(oldBallX + 3, oldBallY + 3), 0, BF

    ' Draw center net (restore dashed line in case ball crossed it)
    For y = 0 To 199 Step 10
        Line (159, y)-(159, y + 5), 8
    Next y

    ' Draw new positions
    Line (10, p1Y)-(10 + paddleWidth, p1Y + paddleHeight), 2, BF
    Line (304, p2Y)-(304 + paddleWidth, p2Y + paddleHeight), 4, BF
    Line (ballX, ballY)-(ballX + 3, ballY + 3), 15, BF

    ' Draw Scores
    Locate 2, 10: Print p1Score;
    Locate 2, 30: Print p2Score;

    ' Force buffer flush for QB64 (if using QB64)
    _Display

LOOP

