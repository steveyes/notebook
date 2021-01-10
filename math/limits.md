# limits





## Using Delta and Epsilon in a Proof

How to find a formula for $$\delta$$ (in terms of $$\epsilon$$) that works.

> **from** $ 0 \lt |x - a| \lt \delta $
>
> **to** $ |f(x) - L | \lt \epsilon $

Let's try to prove that
$$
\lim\limits_{x \to 3} 2x + 4 = 10
$$
Using the letters we talked about above:

- The value that x approaches, "a", is 3
- The Limit "L" is 10

So we want to know, how do we go 

formula-**from**:
$$
0 < |x - 3| < \delta
$$
formula-**to**:
$$
|(2x + 4) - 10| < \epsilon
$$

### Step 1: Play around till you find a formula that might work

1. Start with formula-**to**: 
   $$
   |(2x + 4) - 10| < \epsilon
   $$
2. Simplify:
   $$
   |2x - 6| < \epsilon
   $$
3. Move 2 outside:
   $$
   2|x - 3| < \epsilon
   $$
4. Move 2 across:
   $$
   |x - 3| < \frac{\epsilon}{2}
   $$


### Step 2: Guess 

Now we guess that $\delta = \frac{\epsilon}{2} $ might work

### Step 3: Test to see if that guess works for the formula-from

1. Start with formula-**from**:
   $$
   0 < |x - 3| < \delta
   $$

2. Replace $\delta$ with $\frac{\epsilon}{2}$ (in terms of guess) in the formula-from
   $$
   0 < |x - 3| < \frac{\epsilon}{2}
   $$

3. Move 2 across
   $$
   0 < 2|x - 3|<\epsilon
   $$
   
4. Move 2 inside
   $$
   0 < |2x - 6| < \epsilon
   $$

5. Replace "-6" with "+4-10"
   $$
   0 < |(2x + 4) - 10| < \epsilon
   $$

### Step 4: It works!

We can go from $0 < |x - 3| < \delta$ to $|(2x + 4) - 10| < \epsilon$ by choosing $\delta = \frac{\epsilon}{2}$

So it is true that:

> $\forall$ (for any) $\epsilon$, $\exists$ (there is) a $\delta$
>
> so that $|f(x) - L| < \epsilon$ when $0 < |x - a| < \delta$

And we have proved that

> $ \lim\limits_{x \to 3} 2x + 4 = 10 $



