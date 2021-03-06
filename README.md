# sync_test

### 設定パラメタ

#### ECDの数とそれを数えるためのカウンタのビット幅指定

```
ECD_NUMBER:	integer :=50;
ECD_Q_WIDTH:	integer	:=6
```

このECD数には休みの部分も入る。

ここでは50個のECDを駆動し、１つ休むので50としている（0〜50でカウンタとして51進）

休みの数は１で固定。　カウンタの値が`ECD_NUMBER`の時、ECDが出力されなくなる。

#### バースト波の設定

```
constant BURST_MARK : 	integer := 2;
constant BURST_SPACE:	integer := 1;
constant BURST_Q_WIDTH: integer := 2;
```
- BURST_MARK: 信号の波数
- BURST_SPACE: スペースの波数
- （この２つを足したものがバースト波の全体長さ（波数）になる）

- BURST_Q_WIDTH: バースト波の波数を数えるためのカウンタの幅（BURST_MARK+BURST_SPACEの数を数えられるビット幅にすること）

__注）__ 実際のバースト波は、スペースが先で、その後マークとなる。（ECDの切替を見えなくするため）


#### SYNCパルスの設定

SYNCパルスは、ECDカウンタが最大値（ここでは50）の時に出力される。そのときECDは出力されない。

```
constant SYNC_PULSE_START: integer := 1;
```

- SYNC_PULSE_START: 同期パルスアサートタイミングのバースト波に対する位相（何番目の波から同期パルスをonにするか）
- SYNCはこの開始位相からバーストの最後までアサートされる


##### SYNCパルスタイミング例 (SYNC_PULSE_START:=2 ~ ２番目の波からスタート　＝　カウンタの１からスタート) 
![タイミングチャート例](SYNC_timingExample.png )



