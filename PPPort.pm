
package Devel::PPPort;

require Exporter;
require DynaLoader;
use Carp;

@ISA = (Exporter, DynaLoader);
@EXPORT =  qw();
# Other items we are prepared to export if requested
@EXPORT_OK = qw( );

bootstrap Devel::PPPort;

package Devel::PPPort;
1;

__END__;
