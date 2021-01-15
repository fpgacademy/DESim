// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

package GUI.windows;

/**
 * This class stores all the information required for MessageBox's messages. This class
 * was first used by other classes to store message constants. Originally, those constants
 * were stored as Text objects, the objects need by the MessageBox. However, objects can
 * only be added to the MessageBox once. Therefore, a new Text object must be created
 * each time a given message is to be added to the MessageBox. So, this class was created
 * to solve that issue. Now all messages to be written to the MessageBox must be objects
 * of this class.
 *
 * Objects of this class are immutable.
 */
public final class Message {
    // <editor-fold desc="Variables">
    public final String txt;
    public final MessageType type;
    public final boolean shell;
    // </editor-fold>

    // <editor-fold desc="Constructors">
    public Message(final String txt) {
        this(txt, MessageType.INFO);
    }

    public Message(final String txt, final MessageType type) {
        this(txt, type, false);
    }

    public Message(final String txt, final MessageType type, final boolean shell) {
        this.txt = txt;
        this.type = type;
        this.shell = shell;
    }
    // </editor-fold>
}
