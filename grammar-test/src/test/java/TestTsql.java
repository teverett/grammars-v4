import org.junit.Assert;
import org.junit.Test;

import java.io.File;

public class TestTsql {

    private static File [] ok = new File("../tsql/examples").listFiles(pathname -> pathname.isFile());

    private static File gfiles =  new File("../tsql/tsql.g4");

    @Test
    public void test(){
        Assert.assertTrue(GrammarTester.run(ok, "tsql_file", gfiles));
    }

}
