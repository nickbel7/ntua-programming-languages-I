import java.util.*;

public class BFSolver implements Solver {
    public State solve(State initial) {
        Queue<State> remaining = new ArrayDeque<>();
        Set<State> visited = new HashSet<>();
        // Add first configuration to the queue (tree root)
        remaining.add(initial);
        // Add first configuration to the visited set (tree root)
        visited.add(initial);
        while (!remaining.isEmpty()) {
            State s = remaining.remove();
            if (s.isFinal()) return s;
            // Returns both states for Q and S
            for (State node : s.next()) {
                if (!visited.contains(node)) {
                    remaining.add(node);
                    visited.add(node);
                }
            }
        }
        return null;
    }
}
