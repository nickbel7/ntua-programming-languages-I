import java.util.Collection;

public interface State {
    // Returns true if the configuration is final
    public boolean isFinal();
    
    // Returns a list of all possible next States (one for Q move and one for S move)
    public Collection<State> next();
    
    // Returns previous state
    public State getPrevious();
}
