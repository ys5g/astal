public class Astal.Button : Gtk.Button {
    public signal void hover (HoverEvent event);
    public signal void hover_lost (HoverEvent event);
    public signal void click (ClickEvent event);
    public signal void click_release (ClickEvent event);
    public signal void scroll (ScrollEvent event);

    construct {
        add_events(Gdk.EventMask.SCROLL_MASK);
        add_events(Gdk.EventMask.SMOOTH_SCROLL_MASK);

        enter_notify_event.connect((self, event) => {
            hover(HoverEvent(event) { lost = false });
        });

        leave_notify_event.connect((self, event) => {
            hover_lost(HoverEvent(event) { lost = true });
        });

        button_press_event.connect((event) => {
            click(ClickEvent(event) { release = false });
        });

        button_release_event.connect((event) => {
            click_release(ClickEvent(event) { release = true });
        });

        scroll_event.connect((event) => {
            scroll(ScrollEvent(event));
        });
    }
}

public enum Astal.MouseButton {
    PRIMARY = 1,
    MIDDLE = 2,
    SECONDARY = 3,
    BACK = 4,
    FORWARD = 5,
}

// these structs are here because gjs converts every event
// into a union Gdk.Event, which cannot be destructured
// and are not as convinent to work with as a struct
public struct Astal.ClickEvent {
    bool release;
    uint time;
    double x;
    double y;
    Gdk.ModifierType modifier;
    MouseButton button;

    public ClickEvent(Gdk.ButtonEvent event) {
        var pos = event.get_position();
        this.x = pos.x;
        this.y = pos.y;
        this.time = event.get_time();
        this.button = (MouseButton)event.get_button();
        this.modifier = event.get_modifier_state();
    }
}

public struct Astal.HoverEvent {
    bool lost;
    uint time;
    double x;
    double y;
    Gdk.ModifierType modifier;
    Gdk.CrossingMode mode;
    Gdk.NotifyType detail;

    public HoverEvent(Gdk.CrossingEvent event) {
        var pos = event.get_position();
        this.x = pos.x;
        this.y = pos.y;
        this.time = event.get_time();
        this.modifier = event.get_modifier_state();
        this.mode = event.get_mode();
        this.detail = event.get_detail();
    }
}

public struct Astal.ScrollEvent {
    uint time;
    double x;
    double y;
    Gdk.ModifierType modifier;
    Gdk.ScrollDirection direction;
    double delta_x;
    double delta_y;

    public ScrollEvent(Gdk.ScrollEvent event) {
        var pos = event.get_position();
        this.x = pos.x;
        this.y = pos.y;
        var deltas = event.get_deltas();
        this.delta_x = deltas.delta_x;
        this.delta_y = deltas.delta_y;
        this.time = event.get_time();
        this.modifier = event.get_modifier_state();
        this.direction = event.get_direction();
    }
}
