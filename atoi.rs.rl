//
// Convert a string to an integer.
//

%%{
    machine atoi;
    write data;
}%%

fn atoi(data: &[u8]) -> i32
{
    let mut cs: i32 = 0;
    let mut p = 0usize;
    let mut pe = data.len();
    let mut val = 0i32;
    let mut neg = false;

    %%{
        action see_neg {
            neg = true;
        }

        # Take a look at `fc`. It denotes current symbol
        action add_digit {
            val = val * 10 + (fc - ('0' as u8)) as i32;
        }

        main :=
            ( '-'@see_neg | '+' )? ( digit @add_digit )+
            '\n';

        # Initialize and execute.
        write init;
        write exec;
    }%%

    if neg {
        val = -val;
    }

    if cs < atoi_first_final {
        println!("atoi: error");
    }

    return val;
}


const BUFSIZE: usize = 1024;

fn main() {
    println!("Compiled!");
}

// int main()
// {
//     char buf[BUFSIZE];
//     while ( fgets( buf, sizeof(buf), stdin ) != 0 ) {
//         long long value = atoi( buf );
//         printf( "%lld\n", value );
//     }
//     return 0;
// }
