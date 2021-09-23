import java.util.*;

public class QssortState implements State {
    private Queue<Integer> queue;
    private Stack<Integer> stack;
    private State previous;
    private String sortedQueue;
    private String latestMove;

    // Constructor
    public QssortState(Queue<Integer> q, Stack<Integer> s, String sq, State p, String lm) {
        queue = q;
        stack = s;
        previous = p; 
        sortedQueue = sq;
        latestMove = lm;
    }
    
    // Returns true if the configuration is final
    public boolean isFinal() {
        return queue.toString().equals(sortedQueue);
    }
    
    // Returns a list of all possible next States (one for Q move and one for S move)
    public Collection<State> next() {
        Collection<State> states = new ArrayList<>();
        Queue<Integer> queueClone = new ArrayDeque<>(this.queue);
        Stack<Integer> stackClone = new Stack<Integer>();
        stackClone.addAll(this.stack);
        
        // By inserting first the Q move the BFS return the lexicographically smaller solution
        // Add state Q
        if (!this.queue.isEmpty()) {
            Integer firstElem = this.queue.poll();
            this.stack.push(firstElem);
            states.add(new QssortState(this.queue, this.stack, sortedQueue, this, "Q"));
        }
        // Add state S
        if (!stackClone.isEmpty()) {
            if (!queueClone.isEmpty() && !stackClone.peek().equals(queueClone.peek())) {
                Integer lastElem = stackClone.pop();
                queueClone.add(lastElem);
                states.add(new QssortState(queueClone, stackClone, sortedQueue, this, "S"));
            }
        }
        queueClone = null;
        stackClone = null;

        return states;
    }
    
    // Returns previous state
    public State getPrevious() {
        return this.previous;
    }

    @Override
    public String toString() {
        return this.latestMove;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;

        QssortState qssortState = (QssortState) o;
        return Objects.equals(queue.toString(), qssortState.queue.toString()) && Objects.equals(stack.toString(), qssortState.stack.toString());
    }    

    @Override
    public int hashCode() {
        // PRIME HASHING ALGORITHM
        Integer hashSum=1, prime=31;
        for (Integer x : queue) {
            hashSum = hashSum * prime + x;
        }
        hashSum = hashSum * prime - 1;
        for (Integer x : stack) {
            hashSum = hashSum * prime + x;
        }

        return hashSum;
    }
  
}
